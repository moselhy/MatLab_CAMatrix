function [matrix] = generateMatrix(filename)

% Read Ca coordinates from CSV file
coords = dlmread(filename);
% How many lines are there
nlines = size(coords, 1);
% Get how many residues are there (dimension of matrix)
firstline = coords(1,1);
nres = 0;
for i=2:nlines
    currline = coords(i,1);
    if (mod(firstline,currline)==0)
        nres = i - 1;
        clear firstline;
        clear currline;
        clear i;
        break
    end
end

if (nres == 0)
    print("Error occurred, residues number was 0");
    exit;
end

% Get number of time points
ntimepoints = nlines / nres;

% Generate output matrix
matrix = zeros(ntimepoints, nres, nres);

% Get the distance between each Ca
for i=1:nlines
    % Get the residue ordinal index
%     resnumberi = mod(i,nres) + 1;
    resnumberi = mod(i,nres);
    if resnumberi == 0
        resnumberi = nres;
    end
    % Get the timepoint ordinal index
    timepointnumber = ceil(i/nres);
    x1 = coords(i, 2);
    y1 = coords(i, 3);
    z1 = coords(i, 4);
%     for j=1:nlines
    for j=(((timepointnumber-1)*nres)+1):(timepointnumber*nres)
%         resnumberj = mod(j,nres) + 1;
        resnumberj = mod(j,nres);
        if resnumberj == 0
            resnumberj = nres;
        end        
        x2 = coords(j, 2);
        y2 = coords(j, 3);
        z2 = coords(j, 4);
        matrix(timepointnumber,resnumberi,resnumberj) = distance3d(x1,y1,z1,x2,y2,z2);
    end
end

end