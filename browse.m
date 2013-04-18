% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%
%                               BROWSER FOR THE
%                    ONE-SHOT-LEARNING CHALEARN GESTURE CHALLENGE
%    
%               Isabelle Guyon -- isabelle@clopinet.com -- October 2011
%                                   
% -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
%
% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% ISABELLE GUYON AND/OR OTHER CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
% FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S 
% INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER CONTRIBUTORS 
% BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS, 
% MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE. 

%% Initialization
%clear classes
%close all
this_dir=pwd;

% -o-|-o-|-o-|-o-|-o-|-o-|-o- BEGIN USER-PREFERENCES -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

% 1) User-defined directories (no slash at the end of the names):
% --------------------------------------------------------------
% The present set up supposes that you are now in the directory Sample_code
% and you have the following directory tree, where Challenge is you project directory:
% Challenge/Data
% Challenge/Sample_code

my_root     = this_dir(1:end-12);       % Change that to the directory of your project

data_dir    = [my_root '/Data'];        % Path to the data.
code_dir    = [my_root '/Sample_code']; % Path to the code.

use_recog   = 1;                        % Use a recognizer to process the examples
% -o-|-o-|-o-|-o-|-o-|-o-|-o-  END USER-PREFERENCES  -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

                                    
warning off; 
addpath(genpath(code_dir)); 
warning on;

% Initialize the mode of display RGB ('M') or Depth ('K')
display_mode='M';

h=figure('Name', 'Movie browser');

% Get a batch (creates the databatch object D and eventually a recognizer R)
select_batch;
if ~OK
    close(h);
else

    % Movie navigation
    uicontrol('Position', [10 280 60 20], 'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'String', 'Movie:', 'FontSize', 10);
    % Next
    u0=uicontrol('Parent', h, 'Position', [10 200 60 40], 'FontSize', 12, 'BackgroundColor', [0.5 0.9 0.5], 'String', 'Next >', 'Callback', 'next(D); show(D, display_mode, h, R);');
    % Prev
    u1=uicontrol('Parent', h, 'Position', [10 240 60 40], 'FontSize', 12, 'BackgroundColor', [0.5 0.9 0.5], 'String', '< Prev', 'Callback', 'prev(D); show(D, display_mode, h, R);');
    % Jump to another movie in the same batch
    u3=uicontrol('Parent', h, 'Position', [10 160 60 40], 'FontSize', 12, 'BackgroundColor', [0.9 0.7 0.2], 'String', 'Jump to', 'Callback', ['answer=inputdlg(''Enter number:'',''Jump to'',1,{num2str(num(D))}); if ~isempty(answer), goto(D, str2num(answer{1})); show(D, display_mode, h, R); end']);
    % Jump to another batch
    u4=uicontrol('Parent', h, 'Position', [10 360 120 40], 'FontSize', 12, 'BackgroundColor', [0.1 0.1 0.5], 'ForegroundColor', [1 1 1], 'String', 'Change batch >>', 'Callback', 'select_batch');
    % Toggle RGB and Depth
    uicontrol('Position', [10 140 60 20], 'BackgroundColor', [0 0 0], 'ForegroundColor', [1 1 1], 'String', 'Toggle:', 'FontSize', 10);
    u5=uicontrol('Parent', h, 'Position', [10 100 60 40], 'FontSize', 12, 'BackgroundColor', [.9 .9 0.1], 'String', 'RGB', 'Callback', 'toggle_mode');
  
end


