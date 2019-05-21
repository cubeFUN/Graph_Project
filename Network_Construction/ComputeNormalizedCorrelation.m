function correlation = ComputeNormalizedCorrelation(value0,value1)

	valid = ~isnan(value0) & ~isnan(value1);
	value0 = value0(valid);
	value1 = value1(valid);
	mean0 = mean(value0);
	mean1 = mean(value1);
	std0 = std(value0);
	std1 = std(value1);

	correlation = sum((value0 - mean0) .* (value1 - mean1))/(std0*std1);
    %disp('sum')
    %disp(sum((value0 - mean0) .* (value1 - mean1)))
    disp('value0')
    disp(value0)
    disp('std0')
    disp(std0)
    disp('std1')
    disp(std1)
	%disp('correlation')
	%disp(correlation)
end