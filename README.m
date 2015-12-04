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
% # *One Script from raw data to finalised PDF*. The ideal situation (for me) is if scientists free not only their code but also their data. The act of publishing then would entail people making all their raw data available, with scripts that operate on this raw data and make the final figures in their papers (or, even better, the whole paper). This way, you know _precisely_ what analysis they ran on their data, and how they got to their pretty pictures. 
% # *Automatic version control of code and PDFs.* Every PDF can be uniquely identified to a point in your git history, and every PDF ever generated can be regenerated at any time. This also means that you can precisely know which code was used to generate which figure. (Look at the bottom of this PDF to checkout the code that generated this). 
% # *hashed cache means quick builds of PDFs*. caching intermediate data can greatly speed up subsequent code execution. Do it. But you don't want to mess around with naming this files, or figuring out where they are. |cache.m| is a universal, hash-based caching system that solves all these problems. 
% # *Your paper writes itself* Your paper is ultimately a description of what you did, and what you saw. There's no reason why _what you did_ shouldn't be in the comments of the code you write.
% # *Publication-quality figures* PDFs made in this workflow have a nice embedded vector graphics that can be zoomed into infinitely. 

%% 
% There are some downsides to this:
% 
% # *No interactivity* _Mathmatica's_ notebook (and also python notebooks) are the gold standard here, where comments, text, data, figures and code are incorporated into a single, interactive, notebook. 
% # *No movies in final PDF* But you don't have movies in papers either
% # *Need to re-compile PDF when you change your code*
% # *only works with git* But it should be trivial to modify it for other version control systems

%% How to do it
% Now that you are convinced that this is a good way, the rest of this document describes how to restructure your code and methods to automatically make PDFs from MATLAB code. 

%% 1. Grab Code
% 
%  git clone https://github.com/sg-s/awesome-matlab-publish
%  git clone https://github.com/sg-s/srinivas.gs_mtools
%  

%%
% |prettyFig| is a function that automatically prettifies your figures, making it look nicer and more readable. prettyFig can also be called with particular arguments to change many figure properties with one stroke. 

%% 
% |cache| is my hash-based cache system. |cache(dataHash(X),Y)| stores Y with the hash of X, and |cache(dataHash(X)| retrieves Y. 

%%
% |makePDF| is a wrapper function around MATLAB's |publish| that does it right. 

%% 2. Use a text editor 
% Use a programmer's text editor like SublimeText or emacs. Install MATLAB's linter and build systems. Use snippets and autocompletion. A template for every document that you want to make into a PDF is included in this repo. 

%% 3. Install |pdflatex|
% You should have latex installed. Check that you do with:
%
%  latex --version
%

%% 4. Structure your m file
% 
% # Block comments beginning with %% are printed as text in the PDF. Look at the source of this file or read the docs. 
% # Make sure your figures have a nice paper size. See the source for the syntax and save it as a snippet
% # Delete figures as you create them. Look at the source for the correct syntax.  


%% 5. Make your PDF
% *After* committing all your changes, run |makePDF| to generate your PDF. It will be stored in a holder called |html|. Calling |makePDF| with no arguments will generate a PDF from the last modified file. 


%% Example Figure 
% This is an example figure showing how MATLAB figures are incorporated into the PDF

figure('outerposition',[0 0 1000 500],'PaperUnits','points','PaperSize',[1000 500]); hold on
RandStream.setGlobalStream(RandStream('mt19937ar','Seed',1984)); 
plot(rand(100,1))
xlabel('Time')
ylabel('Something')

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
