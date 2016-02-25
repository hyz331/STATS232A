#include "mex.h"
#include <math.h>
#include <time.h>
#include <stdint.h>

#define MAX_INTENSITY 7 //Max intensity of the image. 255 is too large for experiments. 15 will be much faster.
#define im_width 256 //width of image.
#define im_height 256 //height of image.


void getHistogram(const double *filter, const int width, const int height, const int *image, int *response, const int num_bins, double *filtered)
{
	int i;
	int j;
	int k;
	int l;
	int index;
	int width_index;
	int height_index;
	double mult = (double)num_bins / MAX_INTENSITY;
	double half_num = (double)num_bins / 2;

	for (i = 0; i < im_height; i++)
		for (j = 0; j < im_width; j++)
		{
			index = i * im_width + j;
			filtered[index] = 0;
			for (k = 0; k < height; k++)
			{
				height_index = i + k;
				if (height_index < 0)
					height_index = height_index + im_height;
				else if (height_index >= im_height)
					height_index = height_index - im_height;
				
				for (l = 0; l < width; l++)
				{
					width_index = j + l;
					if (width_index < 0)
						width_index = width_index + im_width;
					else if (width_index >= im_width)
						width_index = width_index - im_width;

					filtered[index] = filtered[index] + filter[k*width+l] * image[height_index*im_width+width_index];
				}
			}
		}
		
	for (i = 0; i < num_bins; i++)
		response[i] = 0;

	for (i = 0; i < im_width * im_height; i++)
	{
		index = mult * filtered[i] + half_num;
		response[index] = response[index] + 1;
	}
}

void Julesz(const double **filters, const int *width, const int *height, const int num_filters, const int num_bins, const double **orig_response, int *synthesized, double *final_response)
{
	time_t start;
	time_t end;

	int i;
	int j;
	int k;
	int l;
	int x;
	int y;
	int x1;
	int y1;
	int x2;
	int y2;
	int W;
	int H;
	int gray;
	double index1;
	int index2;
	int minimum;

	double T;
	double mult = (double)num_bins / MAX_INTENSITY; //This calculation is not exact. mult is the width of each bin of histogram. It should be decided by the minimum and maximum of filter responses.
	double half_num = (double)num_bins / 2;
	double random_num;
	double sum_probs;
	double sum_error;
	int num_iter;

	int *syn_response;
	int **diff_response;
	double **syn_filtered;
	int *difference;
	double *probs;

	syn_response = (int *)malloc(num_bins * sizeof(int));
	diff_response = (int **)malloc(num_filters * sizeof(int *));
	syn_filtered = (double **)malloc(num_filters * sizeof(double *));
	difference = (int *)malloc(num_bins * sizeof(int));
	probs = (double *)malloc((MAX_INTENSITY + 1) * sizeof(double));
	
	for (i = 0; i < num_filters; i++)
	{	
		syn_filtered[i] = (double *)malloc(im_width * im_height * sizeof(double));
		diff_response[i] = (int *)malloc(num_bins * sizeof(int));
		getHistogram(filters[i], width[i], height[i], synthesized, syn_response, num_bins, syn_filtered[i]);

		for (j = 0; j < num_bins; j++)
			diff_response[i][j] = orig_response[i][j] - syn_response[j];
	}

	T = 0.1;
	num_iter = 0;
	sum_error = INT_MAX;
	
	while (sum_error > 0 && num_iter < 50) // annealing
	{
		time(&start);
		for (i = 0; i < im_height; i++)
		{
			for (j = 0; j < im_width; j++)
			{
				gray = synthesized[i*im_width+j];
				
				for (k = 0; k <= MAX_INTENSITY; k++)
					probs[k] = 0;
				
				// for every possible intensity value, 0-255.
				for (k = -gray; k <= MAX_INTENSITY-gray; k++)
				{
					//for every filter
					for (l = 0; l < num_filters; l++)
					{				
						W = width[l];
						H = height[l];
						
						for (x = 0; x < num_bins; x++)
							difference[x] = diff_response[l][x];

						for (x = 0; x < H; x++)
						{
							x1 = H - x - 1;
							x2 = i - x1;
							if (x2 < 0)
								x2 = x2 + im_height;
							else if (x2 >= im_height)
								x2 = x2 - im_height;
							
							for (y = 0; y < W; y++)
							{
								y1 = W - y - 1;
								y2 = j - y1;
								if (y2 < 0)
									y2 = y2 + im_width;
								else if (y2 >= im_width)
									y2 = y2 - im_width;

								//change the histograms
								index1 = mult * syn_filtered[l][x2*im_width+y2] + half_num;
								index2 = index1 + mult * k * filters[l][x1*W+y1];
								
								if ((int)index1 != index2)
								{
									difference[(int)index1] = difference[(int)index1] + 1;
									difference[index2] = difference[index2] - 1;
								}									
							}
						}				
						
						for (x = 0; x < num_bins; x++)
							probs[k+gray] = probs[k+gray] + abs(difference[x]);
					}
				}
						
				minimum = INT_MAX;
				for (k = 0; k <= MAX_INTENSITY; k++)
					if (probs[k] < minimum)
						minimum = probs[k];

				sum_probs = 0;
				for (k = 0; k <= MAX_INTENSITY; k++)
				{
					probs[k] = probs[k] - minimum;
					sum_probs = sum_probs + probs[k];
				}				
				
				for (k = 0; k <= MAX_INTENSITY; k++)
				{
					probs[k] = probs[k] / sum_probs;
					probs[k] = exp(-probs[k] / T);
				}
				
				sum_probs = 0;
				for (k = 0; k <= MAX_INTENSITY; k++)
					sum_probs = sum_probs + probs[k];
				for (k = 0; k <= MAX_INTENSITY; k++)
					probs[k] = probs[k] / sum_probs;

				random_num = (double)rand() / RAND_MAX;
				for (k = 0; k <= MAX_INTENSITY; k++)
				{
					if (random_num < probs[k])
					{
						synthesized[i*im_width+j] = k;
						break;
					}
					else
						random_num = random_num - probs[k];
				}

				for (l = 0; l < num_filters; l++)
				{
					W = width[l];
					H = height[l];
					
					for (x = 0; x < H; x++)
					{
						x1 = H - x - 1;
						x2 = i - x1;
						if (x2 < 0)
							x2 = x2 + im_height;
						else if (x2 >= im_height)
							x2 = x2 - im_height;

						for (y = 0; y < W; y++)
						{
							y1 = W - y - 1;
							y2 = j - y1;
							if (y2 < 0)
								y2 = y2 + im_width;
							else if (y2 >= im_width)
								y2 = y2 - im_width;

							//change the histograms
							index2 = mult * syn_filtered[l][x2*im_width+y2] + half_num;
							diff_response[l][index2] = diff_response[l][index2] + 1;
							
							syn_filtered[l][x2*im_width+y2] = syn_filtered[l][x2*im_width+y2] + (synthesized[i*im_width+j] - gray) * filters[l][x1*W+y1];
							index2 = mult * syn_filtered[l][x2*im_width+y2] + half_num;
							diff_response[l][index2] = diff_response[l][index2] - 1;
						}
					}
				}
			}
		}
		T = T * 0.96;
		num_iter = num_iter + 1;
	
		sum_error = 0;
		for (i = 0; i < num_filters; i++)
			for (j = 0; j < num_bins; j++)
				sum_error = sum_error + abs(diff_response[i][j]);
		sum_error = sum_error / num_filters / num_bins;

		time(&end);
		printf("Iteration %d took %.2lf minutes, error = %.6lf\n", num_iter, difftime(end, start)/60, sum_error);
	}

	for (i = 0; i < num_filters; i++)
		for (j = 0; j < num_bins; j++)
			final_response[j*num_filters+i] = (orig_response[i][j] - diff_response[i][j]) / im_width / im_height;
		
	for (i = 0; i < num_filters; i++)
	{
		free(diff_response[i]);
		free(syn_filtered[i]);
	}
	free(syn_response);
	free(diff_response);
	free(syn_filtered);
	free(difference);
	free(probs);
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])                
{
	int num_bins;
	int num_filters;
	int max_size;
	double *responsematrix;
	double *filtermatrix;

	int *width;
	int *height;
	int i;
	int j;

	double **orig_response;
	double **filters;
	int *synthesized;
	double *syn_response;

	num_bins = mxGetM(prhs[0]);
	responsematrix = mxGetPr(prhs[0]);
	
	max_size = mxGetM(prhs[1]);
	num_filters = mxGetN(prhs[1]);
	filtermatrix = mxGetPr(prhs[1]);
	
	width = (int *)mxGetPr(prhs[2]);
	height = (int *)mxGetPr(prhs[3]);

	filters = (double **)malloc(num_filters * sizeof(double *));
	orig_response = (double **)malloc(num_filters * sizeof(double *));
	
	for (i = 0; i < num_filters; i++)
	{
		orig_response[i] = & responsematrix[num_bins * i];
		
		for (j = 0; j < num_bins; j++)
			orig_response[i][j] = (int)(orig_response[i][j] * im_width * im_height + 0.499999);

		filters[i] = & filtermatrix[max_size * i];
	}

	plhs[0] = mxCreateNumericMatrix(im_width, im_height, mxINT32_CLASS, mxREAL);
	plhs[1] = mxCreateDoubleMatrix(num_filters, num_bins, mxREAL);

	synthesized = (int *)mxGetPr(plhs[0]);
	syn_response = mxGetPr(plhs[1]);

	srand(time(NULL));
	for (i = 0; i < im_width * im_height; i++)
		synthesized[i] = rand() % (MAX_INTENSITY + 1);

	Julesz(filters, width, height, num_filters, num_bins, orig_response, synthesized, syn_response);
	free(orig_response);
	free(filters);
}
