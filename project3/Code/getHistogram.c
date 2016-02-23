#include "mex.h"
#include <math.h>
#include <time.h>

#define MAX_INTENSITY 255 //Max intensity of the image. 255 is too large for experiments. 15 will be much faster.
#define num_bins 15 //Number of bins.

void getHistogram(const double **filter, const int *width, const int *height, const int num_filters, const int *image, const int im_width, const int im_height, double *response)
{
	int i;
	int j;
	int k;
	int l;
	int m;
	int index;
	int width_index;
	int height_index;
	double mult = (double)num_bins / MAX_INTENSITY; //This calculation is not exact. mult is the width of each bin of histogram. It should be decided by the minimum and maximum of filter responses.
	double half_num = (double)num_bins / 2;

	double *filtered;

	filtered = (double *)malloc(im_width * im_height * sizeof(double));

	for (i = 0; i < num_bins * num_filters; i++)
		response[i] = 0;

	for (i = 0; i < num_filters; i++)
	{		
		for (j = 0; j < im_height; j++)
			for (k = 0; k < im_width; k++)
			{
				index = j * im_width + k;
				filtered[index] = 0;
				for (l = 0; l < height[i]; l++)
				{
					height_index = j + l;
					if (height_index < 0)
						height_index = height_index + im_height;
					else if (height_index >= im_height)
						height_index = height_index - im_height;
				
					for (m = 0; m < width[i]; m++)
					{
						width_index = k + m;
						if (width_index < 0)
							width_index = width_index + im_width;
						else if (width_index >= im_width)
							width_index = width_index - im_width;
	
						filtered[index] = filtered[index] + filter[i][l*width[i]+m] * image[height_index*im_width+width_index];
					}
				}
			}	
			

		for (j = 0; j < im_width * im_height; j++)
		{
			index = i * num_bins + mult * filtered[j] + half_num;
			response[index] = response[index] + 1;
		}
	}
	
	free(filtered);


	for (i = 0; i < num_bins * num_filters; i++)
		response[i] = response[i] / im_width / im_height;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])                
{
	int im_width;
	int im_height;
	
	int num_filters;
	int max_size;
	int *image;
	double *filtermatrix;
	int *width;
	int *height;
	int i;

	double **filters;
	double *response;

	im_width = mxGetM(prhs[0]);
	im_height = mxGetN(prhs[0]);
	image = (int *)mxGetPr(prhs[0]);
	
	max_size = mxGetM(prhs[1]);
	num_filters = mxGetN(prhs[1]);
	filtermatrix = mxGetPr(prhs[1]);
	
	width = (int *)mxGetPr(prhs[2]);
	height = (int *)mxGetPr(prhs[3]);

	filters = (double **)malloc(num_filters * sizeof(double *));
	for (i = 0; i < num_filters; i++)
		filters[i] = & filtermatrix[max_size * i];		
	
	plhs[0] = mxCreateDoubleMatrix(1, num_filters * num_bins, mxREAL);
	response = mxGetPr(plhs[0]);

	getHistogram(filters, width, height, num_filters, image, im_width, im_height, response);
	free(filters);
}