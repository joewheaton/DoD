%SAVE2GRAPHIC is based on Gabe Hoffman's Save2PDF
% Unfortunately, SAVE2PDF does not work in Matlab 6.5, because the -dpdf printer
% is not availble in ghostscript in this version! 
% This Saves a figure as a properly cropped image file
%
%   save2tiff(imgFileName,handle,dpi,type)
%
%   - imgFileName: Destination to write the image to.
%   - handle:  (optional) Handle of the figure to write to a tiff.  If
%              omitted, the current figure is used.  Note that handles
%              are typically the figure number.
%   - dpi: (optional) Integer value of dots per inch (DPI).  Sets
%          resolution of output pdf.  Note that 150 dpi is the Matlab
%          default and this function's default, but 600 dpi is typical for
%          production-quality.
%   - type: (option)  image type (default is -dtiff), acceptable options
%   include '-dtiff', '-djpeg', '-depsc', '-deps', '-dill'
%
%   Saves figure with margins cropped to match the figure size.

%   (c) Gabe Hoffmann, gabe.hoffmann@gmail.com
%   Written 8/30/2007
%   Revised by Joe Wheaton 9/27/2007

function f_save2graphic(graphicFileName,handle,dpi,iFormat)

% Verify correct number of arguments
error(nargchk(0,4,nargin));

% If no handle is provided, use the current figure as default
if nargin<1
    [fileName,pathName] = uiputfile('*.tiff','Save to tiff file:');
    graphicFileName = [pathName,fileName];
end
if nargin<2
    handle = gcf;
end
if nargin<3
    dpi = 150;
end
if nargin<4
    iFormat = '-dtiff';
end

% Backup previous settings
prePaperType = get(handle,'PaperType');
prePaperUnits = get(handle,'PaperUnits');
preUnits = get(handle,'Units');
prePaperPosition = get(handle,'PaperPosition');
prePaperSize = get(handle,'PaperSize');

% Make changing paper type possible
set(handle,'PaperType','<custom>');

% Set units to all be the same
set(handle,'PaperUnits','inches');
set(handle,'Units','inches');

% Set the page size and position to match the figure's dimensions
paperPosition = get(handle,'PaperPosition');
position = get(handle,'Position');
set(handle,'PaperPosition',[0,0,position(3:4)]);
set(handle,'PaperSize',position(3:4));

% Save the tiff (this is the same method used by "saveas")
print(handle,iFormat,graphicFileName,sprintf('-r%d',dpi))

% Restore the previous settings
set(handle,'PaperType',prePaperType);
set(handle,'PaperUnits',prePaperUnits);
set(handle,'Units',preUnits);
set(handle,'PaperPosition',prePaperPosition);
set(handle,'PaperSize',prePaperSize);
