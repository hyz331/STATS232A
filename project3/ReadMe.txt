1, "myfilters.m" is a matlab function, which generate a set of filters. Modification: you need to add more filters. For instance, you should at least add the Dirac delta function whose response is the intensity of a given pixel.

2. "getHistogram.c" is a mex c function, which computes the normalized filter response histogram on an image.  Modification: on top of this function, you should also write another one by yourself, e.g., getHistogram2.c, where you can specify the bin range for computing the histogram. Note that the output histogram is normalized by 256 * 256. You need to multiply the normalized histograms by 256 * 256 for computing the difference (error) between two histograms.

3. "Julesz.c" is a mex c funtion, which implements a Gibbs sampling process for the image synthesis. Modifications:
	1) When computing the histograms of input image and the synthesized image, you must use the same bin range. For this, you may compute the maximum and minimum responses of the response of a filter on the input image, and then divide the range equally to obtain the interval of each bin. Use these bin ranges for both input and synthesized image.
	2) Assign different weights to the bins when you calculate the difference between two histograms, e.g.:
	for (x = 0; x < num_bins; x++) {
		probs[k+gray] = probs[k+gray] + abs(difference[x]) * w[x];
	}
	3) Tune the coefficient of the simulated annealing process to improve the synthesis.

4. "temp.m" is an example of the filter selection process. Note that this naïve script does not work, since the filters should be selected based on the information gain, not in the order of "1,2,3,4,5" shown in the script, and the bin ranges should be computed based on the filters’ responses on the input image.

5.  Write your own main script to replace “temp.m”, which should include the following main steps of the learning algorithm:
1) Generate a filter bank by “myfilters.m”.
2) The set of chosen filters S is initially empty.
3) Randomly sample a synthesized image I (sample the intensity of each pixel uniformly from [0,7]). You may also use other types of initial synthesized image, e.g., an all black image.
4) For each unselected filter, compute its response histogram on both input image and current synthesized image I. Calculate the weighted difference (error) between two histograms.
5) If the highest error is smaller than a threshold, then go to step 8. Otherwise, choose the filter with the highest error and add it to the chosen set S.
6) Use the modified Julesz function to sample a new image I', and replace I with I'. (Hint: the input of the Julesz function includes the synthesized image I from the last iteration, chosen filters set S, histograms of chosen filters' responses on the input image, and the corresponding bin ranges of the histograms.)
7) Compute the total error between the new I and the input image based on the new set S. This is the error that you need to show for the report. Then go to step 4.
8) Output the synthesized image I as the final result.

