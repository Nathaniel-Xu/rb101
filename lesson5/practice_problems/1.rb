arr = ['10', '11', '9', '7', '8']
arr.sort{|val,val_2| val_2.to_i <=> val.to_i}