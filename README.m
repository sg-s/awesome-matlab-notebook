% awesome-matlab-notebook (readme)
%
% created by Srinivas Gorur-Shandilya at 10:08 , 04 December 2015. Contact me at http://srinivas.gs/contact/
%
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.ts


pHeader;

%% Philosophy
% The point of this document is to document *my* way of generating self-documenting code and appealing and accurate visualizations of data. Before I tell you what my workflow is, here is a strawman example of how a real scientist used to organise and name their code:
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
% # *One Script from raw data to finalised PDF*. The ideal situation (for me) is if scientists free not only their code but also their data. The act of publishing then would entail people making all their raw data available, with scripts that operate on this raw data and make the final figures in their papers (or, even better, the whole paper). This way, you know _precisely_ what analysis they ran on their data, and how they got to their pretty pictures. Even if you're not a radical like I am, you probably want to adopt this system because it is also the most secure, and avoids the problem of not knowing which plot came from which data and which version of your code (see below).
% # *Automatic version control of code and PDFs.* Every PDF can be uniquely identified to a point in your git history, and every PDF ever generated can be regenerated at any time. This also means that you can precisely know which code was used to generate which figure. (Look at the bottom of this PDF to checkout the code that generated this. As an exercise, you can generate previous version of this PDF if you want).
% # *Accountability extends to external repositories* Sometimes, your analysis scripts may rely on complex code that lives in its own repository. This workflow automatically finds all dependencies of the script being compiled, and points to their git hashes so you can restore to that state if need be.
% # *hashed cache means quick builds of PDFs*. caching intermediate data can greatly speed up subsequent code execution. Do it. But you don't want to mess around with naming this files, or figuring out where they are. |cache.m| is a universal, hash-based caching system that solves all these problems.
% # *Your paper writes itself* Your paper is ultimately a description of what you did, and what you saw. There's no reason why _what you did_ shouldn't be in the comments of the code you write.
% # *Publication-quality figures* PDFs made in this workflow have a nice embedded vector graphics that can be zoomed into infinitely.

%%
% There are some downsides to this:
%
% # *No interactivity* _Mathematica's_ notebook (and also python notebooks) are the gold standard here, where comments, text, data, figures and code are incorporated into a single, interactive, notebook.
% # *No movies in final PDF* But you don't have movies in papers either
% # *Need to re-compile PDF when you change your code* which can be a drag
% # *only works with git* But it should be trivial to modify it for other version control systems

%% How to do it
% Now that you are convinced that this is a good way, the rest of this document describes how to restructure your code and methods to automatically make PDFs from MATLAB code.

%% 0. Special Note for Windows Users
% It is now possible to use this workflow (in a limited fashion) on Windows computers. Make sure you do the following:
%
% # Install git so that you can use it from the command prompt. Don't install git bash. You know you've done the right thing when you type "git" in the command prompt and you don't get an error message.
% # Scripts here assume you have conventional paths (C:\Program Files), etc.

%% 1. Grab Code
%
%  git clone https://github.com/sg-s/awesome-matlab-notebook
%  git clone https://github.com/sg-s/srinivas.gs_mtools
%

%%
% and remember to add these to your system path.

%%
% |prettyFig| is a function that automatically prettifies your figures, making it look nicer and more readable. |prettyFig| can also be called with particular arguments to change many figure properties with one stroke.

%%
% |cache| is my hash-based cache system. |cache(dataHash(X),Y)| stores Y with the hash of X, and |cache(dataHash(X)| retrieves Y.

%%
% |makePDF| is a wrapper function around MATLAB's |publish| that does it right.

%%
% Assuming you are using |git|, your |.gitignore| file should look something like this (change as needed):
%
%  .DS_Store
%  .gitignore
%  *.mat
%  html/
%  *.pdf
%


%% 2. Use a text editor
% Use a programmer's text editor like *SublimeText* or *emacs*. Install MATLAB's linter and build systems. Use snippets and autocompletion. A template for every document that you want to make into a PDF is included in this repo.

%%
% This repo comes with some sublime text snippets (for example, a skeleton for this entire document). Install them using (on Mac OS X):
%
%  cd /where/is/this/repo
%  cp *.sublime-snippet ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
%

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
% *After* committing all your changes, run |makePDF| to generate your PDF. It will be stored in a folder called |html|. Calling |makePDF| with no arguments will generate a PDF from the last modified file.


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

%% Example Workflows:
% The following examples show you typical things that you might want to do in this workflow:

%% 1. Make a PDF with the current state of analysis
% You are at the stage where you have collected some data, and have written an analysis script, and want to enter this version of the analysis (and the resulting PDF) into the historical record. You want to do the following in your bash prompt:

%%
%
%  # bash
%  cd /where/my/code/is/
%  git add -A .
%  git commit -m 'descriptive comment'
%  git push
%

%%
% Then, in the MATLAB prompt, you want to make the figure:
%
%  % matlab
%  makePDF
%

%%
% makePDF with no arguments should work if it is the last file to be modified. If not, specify the file name.

%% 2. Reproduce an old figure
% You are at advanced state of your project, and a co-worker bursts into your office waving a piece of paper. It is a print-out of an old PDF, with an analysis you did 6 months ago, using techniques you scrapped 3 months ago. But she has found something interesting in one of the plots you have made, and wants you to reproduce this. Read the identifying information from the PDF (it should have the commit in the end) and do the following:

%%
%
%  # git
%  git checkout -b 'exciting-old-branch-name' <hash from PDF>
%  # verify that the hash of the file in question matches
%  md5 <file-name>
%

%%
% Now, in your MATLAB prompt, you can reproduce that exact PDF using:
%
%  makePDF('filename.m')
%



%%
% The following information is automatically generated (see the source), and helps you identify every document, and ensures that you can always know precisely which code generated the figures in this document.

%% Version Info
% The file that generated this document is called:
pFooter;
