function out = NormalizeData(img_in)
if(size(img_in,3)==3)
    min_val = min(min(min(img_in)));
    img_in = img_in + min_val;
    max_val = max(max(max(img_in)));
    out = img_in/max_val;
else
    min_val = min(min(img_in));
    img_in = img_in + min_val;
    max_val = max(max(img_in));
    out = img_in/max_val;
end
end