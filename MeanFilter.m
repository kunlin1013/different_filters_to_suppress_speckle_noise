function IMG =  MeanFilter(img,varargin)
    % img : input image
    % IMG : output image => invert to uint8
    
    defaultwindow_m = 3;
    defaultwindow_n = 3;
    % window_m, window_n : m×n window region
    
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'img',@(x) validateattributes(x,{'numeric'},{}));
    addOptional(p,'window_m',defaultwindow_m,validScalarPosNum);
    addOptional(p,'window_n',defaultwindow_n,validScalarPosNum);
    parse(p,img,varargin{:});

    % window size
    sz = [p.Results.window_m p.Results.window_n];
    if(~all(mod(sz,2) == [1 1]))
        sz = sz + ~mod(sz,2);
    end

    h = fspecial('average',sz);
    IMG = uint8(imfilter(p.Results.img,h,'symmetric'));
end