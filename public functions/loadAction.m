function [data] = loadAction(folder, action, varargin)
% loadData --- loads the MoCap streams of an action specified by the user.
%              
%              Input: 
%                   - folder: path of the folder in which mat structures 
%                       are stored.
%                   - action: name of the action that needs to be loaded.
%                   - marker (optional): a single string between 'SHOULDER',
%                       'ELBOW', 'WRIST', 'PALM', 'IND' and 'LIT'.
%                       'ALL' to retrieve MoCap data from each marker.
%                   - instance (optional): a number identifying a single
%                       instance of the action.
%              
%              This function will give you the possibility to load only
%              part of the Cooking Dataset by specifying and action, a
%              marker, or an instance.
%              
%              Output:
%                   [data] = structure containing the subset of data
%                       requested by the user.
%
% Example of use:
% folder = '../cooking dataset/data/training/';
% action = 'dish';
%  - loadAction(folder, action) and loadAction(folder, action, 'ALL') 
% return a struct containing data of all markers for the action specified.
%  - loadAction(folder, action, marker) returns a struct containing data of
% the marker specified for the action in 'action'.
%  - loadAction(folder, action, 'ALL', instance) returns a struct 
% containing data of all markers at the specified instance of  the action.
%  - loadAction(folder, action, marker, instance) returns a struct 
% containing data of a single marker at the specifies instance of the
% action.
%
    % check if the folder path ends in '/' or not
    % if it does, comment line 37
    folder = strcat(folder,'/');
    mode = strsplit(folder, '/');
    
    % Load the complete action
    if(isempty(varargin) || (size(varargin,2) == 1 && strcmp(char(varargin{1}), 'ALL')))
        filename = dir(strcat(folder,'*',lower(action),'*.mat'));
        file = load(strcat(folder,filename.name));
        
        nameStruct = strcat(lower(action),'_', char(mode(end-1)), '.mat');
        actionStruct = matfile(nameStruct, 'Writable', true);
        
        actionStruct.IND = file.IND(:,:);
        actionStruct.PALM = file.PALM(:,:);
        actionStruct.LIT = file.LIT(:, :);
        actionStruct.WRIST = file.WRIST(:,:);
        actionStruct.ELBOW = file.ELBOW(:,:);
        actionStruct.SHOULDER = file.SHOULDER(:,:);
        
        data = load(nameStruct);
        fprintf('File %s saved.\n',nameStruct);
    
    elseif(~isempty(varargin))
        filename = dir(strcat(folder,'*',lower(action),'*.mat'));
        file = load(strcat(folder,filename.name));
        marker = upper(char(varargin{1}));
        
        % Load a specific marker of the action
        if(size(varargin,2)==1)
            nameStruct = strcat(lower(action),'_', lower(marker), '_', char(mode(end-1)), '.mat');
            actionStruct = matfile(nameStruct, 'Writable', true);

            actionStruct.(marker) = file.(marker);
        
        % Load a specific instance of the action
        elseif(size(varargin,2)==2)
            i = varargin{2};
            ind = file.index;
                    
            if(i < (size(ind,2)-1))
                if(strcmp(marker,'ALL'))
                    nameStruct = strcat(lower(action),'_',int2str(i),'.mat');
                    actionStruct = matfile(nameStruct, 'Writable', true);
            
                    actionStruct.IND = file.IND(ind(i):ind(i+1), :);
                    actionStruct.PALM = file.PALM(ind(i):ind(i+1), :);
                    actionStruct.LIT = file.LIT(ind(i):ind(i+1), :);
                    actionStruct.WRIST = file.WRIST(ind(i):ind(i+1), :);
                    actionStruct.ELBOW = file.ELBOW(ind(i):ind(i+1), :);
                    actionStruct.SHOULDER = file.SHOULDER(ind(i):ind(i+1), :);
                else
                    nameStruct = strcat(lower(action),'_',lower(marker),int2str(i),'_', char(mode(end-1)), '.mat');
                    actionStruct = matfile(nameStruct, 'Writable', true);
                    actionStruct.(marker) = file.(marker)(ind(i):ind(i+1),:);
                end
            end
        end
        data = load(nameStruct);
        fprintf('File %s saved.\n', nameStruct);
    end
end