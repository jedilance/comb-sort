template<typename T>
void comb_sort(T* input, int size, bool ascending)
{
	int temp;
	int i, gap = size;
	bool swapped = false;
	
	//Checking to see if the gap value has reached one and no swaps have occurred.
	//If so, then the set has been sorted.
	while ((gap > 1) || swapped)
	{
		//Calculation of the gap value.
		if (gap > 1)
		{
		    gap = (int)((double)gap / 1.3);
		}
		swapped = false;
		
		for (i = 0; gap + i < size; ++i)
		{
		    if(ascending)	//ascending ordering
		    {
		        if (input[i] - input[i + gap] > 0)
		        {
		            temp = input[i];
		            input[i] = input[i + gap];
		            input[i + gap] = temp;
		            swapped = true;
		        }
		    }
		
		    else	// descending ordering
		    {
		        if (input[i] - input[i + gap] < 0)
		        {
		            temp = input[i + gap];
		            input[i + gap] = input[i];
		            input[i] = temp;
		            swapped = true;
		        }
		    }
		}
	}
}