function eegplugin_EEGbatch(fig,try_strings,catch_strings)


newmenu = uimenu(fig,'Label','EEGbatch');
newsubmenu = uimenu(newmenu,'Label','EEGbatch','callback','EEGbatch;');
