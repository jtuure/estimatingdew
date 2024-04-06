%This function takes in an array and converts it from cell to double. As
%sometimes FMI (Finnish Meteorological Institute) data appears as cell
%instead of double.
function outputArray = convertToDoubleArray(inputArray)
    if ~isnumeric(inputArray)
        stringArray = cellfun(@string, inputArray);
        doubleArray = str2double(stringArray);
        outputArray = doubleArray;
    else
        outputArray = inputArray;
    end
end