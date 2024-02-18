function IMG = LeeFilter(img,varargin)
    % img : input image
    % IMG : output image => invert to uint8

    img = double(img);
    % window_m, window_n : m×n window region
    defaultwindow_m = 3;
    defaultwindow_n = 3; 
    sz = [defaultwindow_m defaultwindow_n];
    % additive noise variance
    default_additive_noise = mean2(filter2(ones(sz), img.^2) / prod(sz) - filter2(ones(sz), img) / prod(sz).^2);
    
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'img',@(x) validateattributes(x,{'numeric'},{}));
    addOptional(p,'window_m',defaultwindow_m,validScalarPosNum);
    addOptional(p,'window_n',defaultwindow_n,validScalarPosNum);
    addOptional(p,'additive_noise',default_additive_noise,validScalarPosNum);
    parse(p,img,varargin{:});
    
    % window size
    sz = [p.Results.window_m p.Results.window_n];

    % Preallocate the Output Matrix
    IMG = zeros(size(p.Results.img));
    if(~all(mod(sz,2) == [1 1]))
        sz = sz + ~mod(sz,2);
    end
    mn = round((sz - 1) / 2);

    % Padding with symmetric around the border
    img_padding = padarray(p.Results.img,mn,'symmetric');

    % Estimate the local mean of f.
    localMean = filter2(ones(sz), p.Results.img) / prod(sz);

    % Estimate of the local variance of f.
    localVar = filter2(ones(sz), p.Results.img.^2) / prod(sz) - localMean.^2;
    if (p.Results.additive_noise == default_additive_noise)
        noise = mean2(localVar);
    else
        noise = p.Results.additive_noise;
    end
    for i = 1:size(p.Results.img,1)
        for j = 1:size(p.Results.img,2)
            % Local Window
            K = img_padding(i:i+sz(1,1)-1,j:j+sz(1,2)-1);

            % Mean value of the pixels in the local window
            meanV = mean(K(:));

            % variance of the pixels in the local window
            varV = var(K(:));

            % Weight for each pixel in the local window
            Weight = varV / (varV + noise);

            % Filtering
            IMG(i,j) = meanV + Weight * (p.Results.img(i,j) - meanV);
        end
    end
    IMG = uint8(IMG);
end