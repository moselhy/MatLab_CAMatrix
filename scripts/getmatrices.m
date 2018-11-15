function [RMSD] = getmatrices(datadir)
% uncomment the next line and comment the above line for debugging only (to
% keep the variables in the workspace after execution)
% datadir = 'amber';

%% House keeping (preallocate all matrices into proper sizes)

% Get a list of all the files in the directory given as the parameter and
% sort them in a vector
filelist = dir(fullfile(datadir,'*.csv'));
files = natsortfiles(fullfile({filelist.folder}, {filelist.name}));
files = string(files);
% Get the number of files
nfiles = size(files, 2);
% Parse the first files to get necessary information later
first = dlmread(files(1));

% How many lines are there
nlines = size(first, 1);

% Get how many residues are there (dimension of matrix)
firstresidue = first(1,1);
nres = 0;
for i=2:nlines
    currline = first(i,1);
    if (mod(firstresidue,currline)==0)
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

%% Start calculating RMSD

% Create an empty 3D matrix to store RMSD of each window
RMSD = zeros(nfiles, nres, nres);
% Iterate through each window
for i = 1:nfiles
    % Get the file name of the window
    file = files(i);
    % Get a 3D Matrix of Ca-Ca distances, size of (timepoints x residues x residues)
    M = generateMatrix(file);
    % Preallocate a matrix to store the squared deviation
    SD = zeros(ntimepoints-1, nres, nres);
    for j = 1:size(M,1)-1
        SD(j,:,:) = M(j,:,:) - M(j+1,:,:);
    end
    % Square it element-wise
    SD = SD .^ 2;
    % Add all (number of time points - 1) squared-deviations
    sumRMSD = sum(SD);
    % Take the mean of all squared deviations
    meanRMSD = sumRMSD / (nres * nres);
    % Store the RMSD value for the window (9 x 9 matrix)
    RMSD(i,:,:) = sqrt(meanRMSD);
end


%% Plot the average RMSDs for each residue window

% Get the folder name in uppercase (force-field)
forcefield = upper(string(datadir));

% Get the average RMSD of each window
avgWindowRmsd = mean(mean(RMSD,2),3)';
hold on;
plot(avgWindowRmsd, 'DisplayName', forcefield);

title("Average C?-C? RMSD of Nonphosphorylated MD 9-mers");

% Labels for axes
ylabel("Average RMSD (Å)");

% x = 1:1:nwindows;
x = linspace(63,82,20);
% strx = string(x);
% for i = 1:20
%     strx(i) = sprintf("%s_%s", string(x(i)), string(x(i) + 8));
% end
% strx = strrep(strx, '_', '\_');
set(gca, 'xtick', 1:20)
set(gca,'xticklabel',x)
xlabel("Residue Window");

% Show legend
legend show;
