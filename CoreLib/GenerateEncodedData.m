%% Generate random data
% random info bits and there encoding 
function [ qam_data, info_bits, encoded_bits] = GenerateEncodedData( ChCode)
% CC Encoding
info_bits = randi([0 1],ChCode.Nr_infobits,1); % here we skip scrambling, coz we have randomly generated the source bit sequence.
[ qam_data, encoded_bits] = Encoder( ChCode, info_bits);
end