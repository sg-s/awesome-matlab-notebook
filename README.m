% 
% 
% created by Srinivas Gorur-Shandilya at 10:08 , 04 December 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.ts


% add homebrew path
path1 = getenv('PATH');
if isempty(strfind(path1,':/usr/local/bin'))
    path1 = [path1 ':/usr/local/bin'];
end
setenv('PATH', path1);

% this code determines if this function is being called
calling_func = dbstack;
being_published = 0;
if ~isempty(calling_func)
	if find(strcmp('publish',{calling_func.name}))
		being_published = 1;
		unix(['tag -a publish-failed ',which(mfilename)]);
		unix(['tag -r published ',which(mfilename)]);
	end
end
tic

%% Philosophy 
% The point of this document is to document *my* way of generating self-documenting code and beautiful and accurate visualizations of data. Before I tell you what my workflow is, here is a strawman example of how a real scientist used to organise and name their code:
% 
% <</code/awesome-matlab-notebook/images/analysis.png>>

%%
% This is clearly a terrible way to do things. Here is how I do this:
% 
% <</code/awesome-matlab-notebook/images/workflow.png>>

%%
% 


%%
% This workflow has many advantages:
%
% # *One Script from raw data to finalised PDF*. The ideal situation (for me) is if scientists free not only their code but also their data. The act of publishing then would entail people making all their raw data available, with scripts that operate on this raw data and make the final figures in their papers (or, even better, the whole paper). 
% # Automatic version control of code and PDFs. Every PDF can be uniquely identified to a point in your git history, and every PDF ever generated can be regenerated at any time. This also means that you can precisely know which code was used to generate which figure. 
% # hashed cache means quick builds of PDFs
% # Your paper writes itself 
% # Publication-quality figures

%% 
% There are some downsides to this:
% 
% # No interactivity (like Mathematica's manipulate)
% # No movies in final PDF (but you don't have movies in papers either)
% # Need to re-compile PDF when you change your code 
% 






prettyFig()

if being_published
	snapnow
	delete(gcf)
end


%% Version Info
% The file that generated this document is called:
disp(mfilename)

%%
% and its md5 hash is:
Opt.Input = 'file';
disp(dataHash(strcat(mfilename,'.m'),Opt))

%%
% This file should be in this commit:
[status,m]=unix('git rev-parse HEAD');
if ~status
	disp(m)
end

t = toc;

%% 
% This document was built in: 
disp(strcat(oval(t,3),' seconds.'))

% tag the file as being published 

if being_published
	unix(['tag -a published ',which(mfilename)]);
	unix(['tag -r publish-failed ',which(mfilename)]);
end
