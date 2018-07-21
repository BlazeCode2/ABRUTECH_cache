clear all,close all,clc


% width=cell2mat(inputdlg('Enter memory word size.'));
% depth=cell2mat(inputdlg('Enter memory depth.'));
width='32';
depth='128';

file=fopen('memory.mif','w');
string1=['DEPTH = %s; %% Memory depth and width are required %%\n', ...
'             %% DEPTH is the number of addresses %%\n' ...
'WIDTH = %s; %% WIDTH isfprin the number of bits of data per word %%\n' ...
'             %% DEPTH and WIDTH should be entered as decimal numbers %%\n' ...
'ADDRESS_RADIX = DEC; %% Address and value radixes are required %%\n' ...
'DATA_RADIX = DEC; %% Enter BIN, DEC, HEX, OCT, or UNS; unless %%\n' ...
'             %% otherwise specified, radixes = HEX %%\n' ...
'-- Specify values for addresses, which can be single address or range\n' ...
'CONTENT\n' ...
'BEGIN\n'];

fprintf(file,string1,depth,width);
for i =[0:127]
    num=[(4*mod(i,64))+3:-1:4*mod(i,64)];
    num=dec2bin(num,8);
    num=num';
    num=num(:)';
    num=num2str(bin2dec(num));
    fprintf(file,'%s    :   %s;\n',num2str(i),num);
    
end
fprintf(file,'--\nEND');
fclose(file);
