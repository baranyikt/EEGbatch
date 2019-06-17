%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%   EEGbatch: Batch processing extension for EEGLAB toolbox   %
%   (installs itself as an EEGLAB plugin)                     %
%   [ https://sccn.ucsd.edu/eeglab/ ]                         %
%   Written by:         Károly BARANYI                        %
%                    [ eegbatch@gmail.com ]                   %
%                            2012                             %
%                                                             %
%   version: 0.2--2012-07-30                                  %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function EEGbatch
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C_EEGBATCH_VER = 'v0.2.003d'; VAR_DEBUG = (C_EEGBATCH_VER(end) == 'd');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------- SETTINGS -----------------------------------
VAR_MutexEnabled = 1; 
VAR_ErrorLog_MutexEnabled = VAR_MutexEnabled;
VAR_PerfInd_MutexEnabled = VAR_MutexEnabled;					% Mutex master switch for PI component. Separate mutexes for each
VAR_ExtendedLog_MutexEnabled = VAR_MutexEnabled;				% file we working on are controlled by VAR_MutexEnabled
VAR_DefaultPluginDir = '';
VAR_DefaultDir = 'F:\';		
VAR_AutoSelect = 0;
VAR_AutoRun = 0;
VAR_PerfInd_Enabled = 1;
VAR_PerfInd_HideMe = 0;
VAR_PerfInd_NoRecalc = 0;
VAR_LogToFile = 1;
VAR_ErrorLog = 1;
VAR_SeparateLogFiles = 0;
VAR_ExtendedLog = 1;

VAR_LogMemState = 1;
VAR_DatasetLogging = 1;
VAR_RunTimer = 0;
VAR_RunTimerStart = [22 0 0];
VAR_RunTimerEnd = [7 0 0];
VAR_WeekendRun = 1;
VAR_CooldownTimer_Enabled = 1;
VAR_CooldownTimer_Interval = [3 0 0];
VAR_CooldownTimer_Duration = [0 15 0];
VAR_SearchAgainWait = [0 15 0];
VAR_OptRatio_Roundup = 1.1;
VAR_OptRatio_Override = -1;
VAR_ThrowExceptions = 0;
VAR_DatasetLogging_UsePopcomments = 0;
VAR_DatasetLogging_UseNewVar = 0;
VAR_DropComp_MakeAuto = 1;
VAR_IDropComp_MakeAuto = 1;
VAR_DropComp_PrtScr = 1;
VAR_DropEpoch_EEGLAB = 1;
VAR_DropEpoch_MakeAuto = 1;
VAR_DropEpoch_SaveRejectStruct = 1;
VAR_DISP = 1;
VAR_DISPmain = 1;
VAR_LogPluginBenchmark = 1;
VAR_ProfilingEnabled = 1;
VAR_DetailedExceptions = 1;
VAR_StrictFileRules = 0;

% (to restore original defaults, replace: s/% **BE112** //g (perl-regex) and delete variable definitions above

%
%
%
% ----------------- SETTINGS-DEFAULTS ----------------------
%
%
%
% --- These are the settings most users interested in. Most of these have 
% their main window equivalents, but their defaults can be set here as well.

% **BE112** VAR_MutexEnabled = not(VAR_DEBUG); 
% valid values: 0 v. 1
% mainwindow-equivalent: "Network mode"
% recommended: 1
%     If 1, EEGbatch assumes it works on network shared folders and
%     have to protect the files in use with special ".lock" files (working  
%     as a kind of mutex between the different EEGbatch instances and helping
%     synchronize their workflow).
%     You can set it to 0 if you can be absolutely sure that no other EEGLAB
%     or EEGbatch instances will use the data files simultaneously (thus 
%     fastening up EEGbatch a little bit). Strongly recommended to leave it 1.

% **BE112** VAR_DefaultPluginDir = '';
% valid values: full path of any local directory on the computer or ''
% mainwindow-equivalent: "Common plugin directory (if exists)"
% recommended: no particular recommendation
%     EEGbatch searches for different plugins in the usual Matlab PATH and 
%     the current working directory by default. With this option an additional 
%     (common) plugin directory can be given, there you can put all the 
%     EEGbatch plugins that you plan to use independetly of the current 
%     working directory. If you don't need it, leave it empty ('').

% **BE112** VAR_DefaultDir = 'F:\';		
% valid values: full path of any local directory on the computer or ''
% mainwindow-equivalent: "Folder to process"
% recommended: no particular recommendation
%     Default value of working directory, where the datafiles are to be
%     processed. If you click on "..." besides "Folder to process", this
%     will be the directory where you can start browsing. Futhermore, it
%     can be combined with VAR_AutoSelect setting: if that's true (1),
%     this folder will actually be selected without asking.
%     If you've got one working directory that rarely changes, this is
%     the mode of operation for you. See also VAR_AutoRun.
        
% **BE112** VAR_AutoSelect = 0;
% valid values: 0 v. 1
% mainwindow-equivalent: <none>
% recommended: 0
%     Setting the working directory automatically to VAR_DefaultDir can be 
%     enabled here. If VAR_DefaultDir above is not empty and VAR_AutoSelect
%     is set to 1, working directory will automatically be set to that at
%     startup, though you can change it later. 

% **BE112** VAR_AutoRun = 0;
% valid values: 0 v. 1
% mainwindow-equivalent: <none>
% recommended: 0
%     If VAR_DefaultDir contains a valid working directory and VAR_AutoSelect 
%     is true (1), VAR_AutoRun can be used to let EEGbatch start in AUTO mode,
%     thus processing the non-interactive stages automatically after startup.
%     For example, you can use one dedicated instance of EEGbatch to run stages
%     that can be automated and used other EEGbatch copies on the same shared
%     folder for stages needing human interaction. (Of course this scenario
%     needs VAR_MutexEnabled to be 1 in all EEGbatch instances on the network.)
%     Even in AUTO mode, EEGbatch can be stopped anytime by clicking on the
%     STOP button.

% **BE112** VAR_PerfInd_Enabled = VAR_MutexEnabled;
% **BE112** VAR_PerfInd_HideMe = 0;
% **BE112** VAR_PerfInd_NoRecalc = 0;
% valid values: 0 v. 1 (for all 3)
% mainwindow-equivalent: <none>
% recommended: 1, 0, 0 (in order)
%   Settings of the Performance Index component. PI's task is to measure
%   computation capabilities of different machines working on the same 
%   project (in the same working directory) and store the result (the
%   performance index) in a file (PERFIND.MAT) for all computers. This
%   helps EEGbatch in the distribution of different computation-heavy
%   tasks between the workers. If you're using EEGbatch on only one 
%   computer, it's meaningless to measure its performance, so you can 
%   turn it off (that's why it's connected with the VAR_MutexEnabled
%   variable by default). The other two settings are for fine-tuning this 
%   measurement method as follows:
%		VAR_PerfInd_HideMe			Set to 1, if despite the PI component is 
%                               enabled, we don't want to include this
%                               particular computer in the performance index
%                               table. Useful if this computer is not often
%                               participate in the project and we don't want
%                               to unsettle the established balance of the 
%                               steady workers' performance ratios.
%		VAR_PerfInd_NoRecalc		Set to 1 to completely disable (the otherwise 
%								not too often, but regularly repeated) performance
%								measurement for this computer and freeze performance 
%                               ratio at the last measured value.


% **BE112** VAR_LogToFile = 1;
% valid values: 0 v. 1
% mainwindow-equivalent: "Log to file"
% recommended: 1
%     Though EEGbatch logs each stage into the datasets themselves, here
%     logging to a separate, common logfile can be enabled (which is more
%     detailed). The logfile's name will be created in the working directory
%     with the following name format: EEGbatch_log<number>.txt, where number
%     varies from run to run, different on each working computer. This way it
%     can be easily followed which computer did what and when on the project 
%     (if interested).
% **BE112** VAR_ErrorLog = 1;
% **BE112** VAR_SeparateLogFiles = 0;
% **BE112** VAR_ExtendedLog = 1;
% **BE112** VAR_LogMemState = 1;
% **BE112** VAR_DatasetLogging = 1;
% **BE112** VAR_DatasetLogging_UsePopcomments = 0;
% **BE112** VAR_DatasetLogging_UseNewVar = 0;
% valid values: 0 v. 1 (for all of them)
% recommended: 1,0,1,1,1,0,0 (in order)
%		VAR_SeparateLogFiles: Set to 1 to use a different logfile for every job
%			If it's 0, EEGbatch will start a new logfile only a) after working directory has 
%           changed, or b) EEGbatch restarted
%       VAR_ExtendedLog: makes EEGbatch include some extended (debug) information in the logfiles.
%			It can be left at 0.
%		VAR_LogMemState: set to 1 to include memory statistics in the log
%       VAR_DatasetLogging: here you can turn on/off logging to the dataset files themselves

% **BE112** VAR_RunTimer = 0;
% valid values: 0 v. 1
% mainwindow-equivalent: "Timer"
% recommended: nothing particular
%     Sets time constraints for EEGbatch's AUTO mode. If enabled, EEGbatch
%     will search for jobs only between the given start and end time (out 
%     of office hours if preferred). See VAR_RunTimerStart and ...End
%     variables too. EEGbatch's non-AUTO standard mode , which can be 
%     started by clicking on "GO" button on the main dialog is not 
%     affected by this switch.

% **BE112** VAR_RunTimerStart = [22 0 0];
% **BE112** VAR_RunTimerEnd = [7 0 0];
% valid values: [hours minutes seconds] where hours is an integer between 0
%               and 23, the others are between 0 and 59
% mainwindow-equivalent: edit boxes below "Timer"
% recommended: e.g. [22 0 0] and [7 0 0] to restrict AUTO mode to night hours
%     Matlab can very much steal CPU time if running some computation-heavy
%     calculation causing the computer to slow down and even irresponsive
%     sometimes. You can restrict EEGbatch to run computation-heavy (usually 
%     AUTO mode) steps within this interval, leaving office hours CPU time 
%     for USER mode steps.
%     Applies only weekdays and doesn't apply to USER mode EEGbatch, 
%     started by pressing the Go button on the main dialog.
%     See also VAR_WeekendRun

% **BE112** VAR_WeekendRun = 1;
% valid values: 0 v. 1
% mainwindow-equivalent: "and weekends"
% recommended: 1
%     If VAR_RunTimer is turned ON (its value is 1) this switch extends
%     weekday intervals given by VAR_RunTimerStart/End by all weekends
%     in accordance with the original concept of VAR_RunTimer: to restrict
%     computation-heavy steps to non-office hours.
%     As all VAR_RunTimerXXXX settings, this doesn't apply to EEGbatch's
%     standard running mode.

% **BE112** VAR_CooldownTimer_Enabled = 1;
% valid values: 0 v. 1
% mainwindow-equivalent: "cooldown timer"
% recommended: 1
%     If set to 1, it directs EEGbatch to leave some time between long
%     batches of AUTO mode tasks as a kind of cooldown for the machine.
%     This feature can be costomized by the following two settings 
%     specifying how long pause should be inserted between how much time
%     of AUTO mode tasks. These variables have the same layout as
%     VAR_RunTimerStart/End: they form a [hour minute second] scheme.
% **BE112** VAR_CooldownTimer_Interval = [3 0 0];
% **BE112** VAR_CooldownTimer_Duration = [0 15 0];

% **BE112** VAR_SearchAgainWait = [0 15 0];
% **BE112** VAR_OptRatio_Roundup = 1.1;
% **BE112** VAR_OptRatio_Override = -1;
% **BE112** VAR_ThrowExceptions = VAR_DEBUG; % v0.1.016
% **BE112** VAR_DropComp_MakeAuto = 1;
% **BE112** VAR_DropComp_PrtScr = 1;
% **BE112** VAR_DropEpoch_EEGLAB = 1;
% **BE112** VAR_DropEpoch_MakeAuto = 1;
% **BE112** VAR_DropEpoch_SaveRejectStruct = 1;
% **BE112** VAR_DISP = 1;
% **BE112** VAR_DISPmain = 1;
% **BE112** VAR_LogPluginBenchmark = 1;
% **BE112** VAR_ProfilingEnabled = 1;
% **BE112** VAR_DetailedExceptions = 1;
% **BE112** VAR_StrictFileRules = 0;
% **BE112** VAR_ErrorLog_MutexEnabled = VAR_MutexEnabled;
% **BE112** VAR_PerfInd_MutexEnabled = VAR_MutexEnabled;					% Mutex master switch for PI component. Separate mutexes for each
% **BE112** VAR_ExtendedLog_MutexEnabled = VAR_MutexEnabled;				% file we working on are controlled by VAR_MutexEnabled


%
%
%
% ----------------- TRANSLATE ---------------------
%
%
%
C_MSG_NOEEGLAB_ERR = 'ERROR: EEGLAB is not loaded. Please run EEGLAB first, then return to EEGbatch. EEGbatch will now exit.\n';
C_MSG_VLOGCLC = 'Screen log size exceeded %u lines, restarting. (Filelog and others are not affected.)';
C_MSG_OPT_RATIO_INFOLINE1 = '[opt_ratio: ON  opt_ratio_planned %u opt_ratio_all %u opt_ratio_skipped %u opt_ratio_mutexed %u]';
C_MSG_OPT_RATIO_INFOLINE2 = '[opt_ratio: OFF opt_ratio_planned %u opt_ratio_all %u opt_ratio_skipped %u opt_ratio_mutexed %u]';
C_MSG_PI_MTX_WAITING = 'Waiting until %s become available (%u seconds at most)...';
C_MSG_ELOG_MTX_WAITING = 'Waiting until %s become available (%u seconds at most)...';
C_MSG_XLOG_MTX_WAITING = 'Waiting until %s become available (%u seconds at most)...';
C_MSG_OPTABLECHANGED_EXTTYPES = {'*.txt','Text files (*.txt)';'*.*','All files (*.*)'};
C_MSG_DROPCOMP_Q = 'In this stage, please choose Reject data using ICA and then Reject components by map from EEGlab''s Tools menu. Having finished that, choose Tools | Remove compnents, then click OK.';
C_MSG_DROPCOMP_TITLE = '%s';
C_MSG_DROPCOMP_Q_PRTSCR = 'In this stage, please choose Reject data using ICA and then Reject components by map from EEGlab''s Tools menu. Having finished that, take a screenshot using PrtScr (Print Screen) button, then choose Tools | Remove compnents, then click OK.';
C_MSG_DROPCOMP_TITLE_PRTSCR = '%s';
C_MSG_DROPCOMP_OK = 'OK';
C_MSG_DROPCOMP_CANCEL = 'Cancel';
C_MSG_DROPCOMP_STOP = 'Cancel and Stop';
C_MSG_DROPCOMP_AUTOERR = 'DROPCOMP automation failed to write file %s (despite this the operation itself could be successful): %s /// ';
C_MSG_DROPEPOCH_EEGL_Q = 'In this stage, please choose Reject data epochs and then Reject by inspection from EEGlab''s Tools menu. Having finished that, click OK.';
C_MSG_DROPEPOCH_EEGL_Title = '%s';
C_MSG_DROPEPOCH_EEGL_OK = 'OK';
C_MSG_DROPEPOCH_EEGL_CANCEL = 'Cancel';
C_MSG_DROPEPOCH_EEGL_STOP = 'Cancel and Stop';
C_MSG_DROPEPOCH_AUTOERR = 'DROPEPOCH automation failed to write file %s (despite this the operation itself could be successful): %s /// ';
C_MSG_DROPEPOCH_REJSAVEERR = 'DROPEPOCH automation failed to write file %s (despite this the operation itself could be successful): %s /// ';
C_DISP_DROPEPOCH_CONNECT = '%s: connecting to EEGLAB...';
C_DISP_DROPEPOCH_CONNECTED = 'OK\nWaiting for user...';
C_DISP_DROPEPOCH_FINISH = 'OK, some post-processing and done\n';
C_DISP_DROPEPOCH_INFOLINE = 'Selected %u epoch(s) of total %u, %.1f %%\n';
C_MSG_LOGFILE_INIT = 'EEGbatch %s@%s starts';
C_MSG_PREP19_INIT = 'Preparing data file';
C_MSG_EVENT = '%u event created from channel %u';
C_MSG_EPOCH = 'epochs created (%f-%f, length of each event: %u)';
C_MSG_EPOCH_ERROR = 'error creating epochs (%f-%f), dataset array haven''t splitted: %u x %u';
C_MSG_EPOCH_PARAMERROR = 'If DO_EPOCHS is given -1 for both limit arguments (as it is the case now), then 3rd argument must contain the requested length of epochs (in samples)';
C_MSG_BASELINE = 'baseline remove (%i;%i)';
C_MSG_HIGHPASS = 'highpass (%f)';
C_MSG_LOWPASS = 'lowpass (%f)';
C_MSG_THRESH = 'removing suspicious values, in channels: %u-%u, lower bound: %u, upper bound: %u, nr of epochs removed: %s';
C_MSG_DROPEPOCH = 'removing epochs by hand, comment: [%s], epochs dropped: [%s]'; % v0.1.020
C_MSG_DROPCOMP = 'removing components, removed %u components, comment: [%s], component weights: %s';
C_MSG_DROPCOMP_PRTSCR = 'removing components, removed %u components, comment: [%s], screenshot file: [%s], component weights: %s';
C_DISP_DROPCOMP_OKPRTSCR = 'USER_DROPCOMP: Picture saved from clipboard (%s)\n'; % v0.2.002
C_DISP_DROPCOMP_NOPRTSCR = 'USER_DROPCOMP: No picture found on clipboard\n';
C_MSG_IDROPCOMP_BADPARAM = 'DO_IDROPCOMP needs artefact channels as argument. Probably ill-formed OPtable';
C_MSG_IDROPCOMP_AUTOERR = C_MSG_DROPCOMP_AUTOERR;
C_MSG_IDROPCOMP = 'removing components based on artefact channels (IDROPCOMP), removed %u components, artefact channels [%s], removed components affectedness by those: %s, weights of components: %s';
C_DISP_THRESH_ALLGONE = 'Warning, DO_THRESH dropped everything. Too strict conditions?\n';
C_MSG_ICA = 'ICA [type:%s] [options:%s] [logfile:%s] [conditions:%s]';
C_MSG_PREP19_REJLINES = 'removed header: %u lines // ';
C_MSG_ADDEVENTCH = 'trigger channel added (%u)';
C_MSG_PREPEDF = 'Loading of EDF okay, reference: %s, events: %u';
C_MSG_ADDEVENTCH_EPOCHERR = 'Cannot add new channel if epcohs have created already.';
C_MSG_STARTCLEANUP = 'Cleanup started...';
C_MSG_STARTCONDENSING = 'Condensing logfiles...';
C_MSG_STARTCONDENSINGDONE = 'Done';
C_MSG_STARTMUTEXRELEASE = 'Releasing all mutexes...';
C_MSG_STARTMUTEXRELEASEDONE = 'Done';
C_MSG_ENDCLEANUP = 'End cleanup';

C_MSG_AUTODROPCOMP_FORMATERR_WARN = 'Warning! Ill-formed data in automation file "%s" line %u: %s!';
C_MSG_AUTODROPCOMP_TABERR_WARN = 'Warning! Too few columns in in automation file "%s" line %u!';
C_MSG_AUTODROPCOMP_TOOMUCHWARN = 'Number of warnings reached maximum. Not listing all.';
C_MSG_AUTODROPCOMP_FILEERR = 'File I/O error: file: %s, message %s';
C_MSG_AUTODROPCOMP_AMBIRESULT_WARN = 'Warning! Multiple entries belond to %s. Choosing last one.';

C_MSG_AUTODROPCOMP_NOTFOUND = 'No entry found for datafile. AUTO_DROPCOMP cannot be started!';
C_MSG_AUTODROPCOMP_NTD = 'Entry found in line %u, no components to remove';
C_MSG_AUTODROPCOMP_COMPNOTFOUND = 'Error! Entry found in line %u says %u components to remove, but no component corresponds to weights of %s (min. distance: %s)!';
C_MSG_AUTODROPCOMP_DONE = 'Entry found in line %u, %u components removed properly (Euclidean distances: %s)';
C_MSG_AUTODROPCOMP_ERRORCONVERTING = 'Entry found in line %u, conversion error: %s';
C_MSG_AUTODROPCOMP_DIMMISMATCH = 'Entry found in line %u, but its dimension (%u) doesn''t match data dimension (%u)!';
C_DISP_AUTODROPCOMP_FOUNDCOMP = 'Found component %u->%u, distance %f, max: %f\n';

C_MSG_AUTODROPEPOCH_FORMATERR_WARN = C_MSG_AUTODROPCOMP_FORMATERR_WARN;
C_MSG_AUTODROPEPOCH_TABERR_WARN = C_MSG_AUTODROPCOMP_TABERR_WARN;
C_MSG_AUTODROPEPOCH_TOOMUCHWARN = C_MSG_AUTODROPCOMP_TOOMUCHWARN;
C_MSG_AUTODROPEPOCH_FILEERR = C_MSG_AUTODROPCOMP_FILEERR;
C_MSG_AUTODROPEPOCH_AMBIRESULT_WARN = C_MSG_AUTODROPCOMP_AMBIRESULT_WARN;

C_MSG_AUTODROPEPOCH_NOTFOUND = 'No entry found for datafile. AUTO_DROPEPOCH cannot be started!';
C_MSG_AUTODROPEPOCH_NTD = 'Entry found in line %u, no epochs to mark';
C_MSG_AUTODROPEPOCH_ERRORCONVERTING = C_MSG_AUTODROPCOMP_ERRORCONVERTING;
C_MSG_AUTODROPEPOCH_BOUNDSERR = 'Entry found in line %u, but one of epochs to be marked has index out of range: %i';
C_MSG_AUTODROPEPOCH_DONE = 'Entry found in line %u, marked %u epoch(s)';

C_DI_SETTINGS = 'Settings';
C_DI_MESSAGES = 'Messages';
C_DI_OPDIR = 'Working directory:';
C_DI_OR = 'or';
C_DI_ICHOOSE = 'i choose myself the files one by one';

C_MSG_FILESFOUND = 'found %u files';
C_MSG_FILESCHOSEN = C_MSG_FILESFOUND;
C_MSG_FILESNOTCHOSEN = '';
C_MSG_SEARCHING = 'Loading... %u/%u (%u/%u)';
C_MSG_MUTEXHOLD = 'Holding mutexes...';

C_MSG_AUTOSELECT_ACTIVE = 'AUTO_SELECT option active -> %s selected as working directory';
C_MSG_AUTORUN_ACTIVE = 'AUTO_RUN option active -> running';

C_DI_POPUPDIR = 'Choose working directory';
C_DI_POPUPFILE = 'Choose files to process';
C_DI_LOGTOFILE = 'Logging to file';
C_DI_START = 'Go';
C_DI_USERONLY = 'Restrict to USER mode';
C_DI_STOP = 'STOP';
C_DI_AUTOMODE = 'AUTO mode';
C_DI_TIMER = 'Timer';
C_DI_UNTILTHIS = ' (enabled hours)';
C_DI_COOLDOWN = 'cooldown timer';
C_DI_NETWORKMODE = 'Network mode';
C_DI_WEEKENDRUN = 'and weekends';
C_DI_ETA_RESET = 'nnn/nnn --:--:--';
C_DI_ETA_FORMAT = '%03u/%03u %02u:%02u:%02u';

C_DI_OPTPERCENT = 'Optimal %:';
C_DI_OPTPERCENT_AUTO = 'Auto';
C_DI_COMMONPLUGINS = 'Common plugin directory (if exists):';
C_DI_OPTABLE_EDITOR = 'OP-table-editor';
C_DI_PLUGIN_EDITOR = 'Plugin editor';
C_DI_SAVE_SETTINGS = 'Save settings';
C_DI_RESTART = 'Restart';
C_DI_CLEANUP = 'CLEANUP';
C_DI_SHOW_COMPUTERS = 'Working computers';

C_DI_OPTABLEEDITOR_CAPTION = 'EEGbatch OP-table-editor';
C_DI_OEDITOR = '-';

C_MSG_PRJLABEL = 'Project: %s';
C_MSG_SUBJGRLABEL = 'Subj grp: %s';
C_DI_EOP_UNDO = 'UNDO';
C_DI_EOP_SAVE = 'SAVE';
C_DI_EOP_FIRST = '<<';
C_DI_EOP_LEFT = '<';
C_DI_EOP_RIGHT = '>';
C_DI_EOP_LAST = '>>';
C_DI_EOP_NEW = 'NEW';
C_DI_EOP_REVERT = 'REVERT';
C_DI_EOP_SAVEAS = 'SAVE AS...';
C_DI_EOP_LOADING = 'LOADING...';
C_DI_EOP_SAVING = 'SAVING...';
C_DI_EOP_IDLE = '';
C_DI_EOP_N_OF_M = 'OP-table: %u/%u';

C_MSG_OPTABLECHANGED_Q = 'Modifications made on OP-table. Save?';
C_MSG_OPTABLECHANGED_TITLE = 'Question';
C_MSG_OPTABLECHANGED_SAVE = 'Save';
C_MSG_OPTABLECHANGED_SAVEAS = 'Save as...';
C_MSG_OPTABLECHANGED_REJECT = 'Reject';
C_MSG_OPTABLECHANGED_CANCEL = 'Cancel';

C_MSG_OPTABLECHANGED_SAVE_ERR_Q = 'Error occurred while saving. Try different name?';
C_MSG_OPTABLECHANGED_SAVE_ERR_TITLE = 'Question';
C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE = 'Enter new filename';
C_MSG_OPTABLE_NEWFILE = C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE;

C_MSG_PE_ERRORSAVING = 'Error occurred while saving:';
C_MSG_PE_ERRORSAVING_Title = 'Error!';
C_MSG_PE_CANNOTSAVEEMPTYNAME = 'Plugin name is empty!';
C_MSG_OC_CANNOTSAVEEMPTYPRJ = 'Project name is empty!';
C_MSG_OC_ERRORSAVING_TITLE = 'Error!';
C_MSG_EOP_ERRORSAVING = 'Error occurred while saving:';
C_MSG_EOP_ERRORSAVING_TITLE = 'Error!';
C_MSG_DIRNOTFOUND = 'Directory not found!';
C_MSG_DIRNOTFOUND_TITLE = 'Error!';
C_MSG_CANNOT_AUTOMATE_BYFILES = 'AUTO mode is only available for whole directories';
C_MSG_CANNOT_AUTOMATE_BYFILES_TITLE = 'Error!';
C_MSG_NOWORKDIR = 'No working directory specified. This function requires working directory.';
C_MSG_NOWORKDIR_TITLE = 'Error!';

C_DI_OC_OCREATOR = 'OP-table-creator';
C_DI_OC_PRJ = 'Project:';
C_DI_OC_SUBJGR = 'Subj grp:';

C_DI_OC_STD19 = 'PREP19';
C_DI_OC_STD64 = 'PREP64';
C_DI_OC_OWN = 'own';
C_DI_OC_NONE = 'dataset';
C_DI_OC_ADD_EVENT_CHANNEL = 'New event channel';
C_DI_OC_ADD_EVENT_CHANNEL_AUTO = 'Channel nr auto';
C_DI_OC_EVENTS = 'Create events';
C_DI_OC_EVENT_CHANNEL_AUTO = 'Channel nr auto';
C_DI_OC_POP_IMPORT = 'Import mode:';
C_DI_OC_FILES = 'Input filename:';
C_DI_OC_PHASE = 'Input stage:';
C_DI_EOP_UNSAVED = '<unsaved>';
C_DI_OC_EVENT_STEP = 'event step';
C_DI_OC_SAMPLING_RATE = 'sampling rate';
C_DI_OC_CHAN_LOCS = 'channel locs';
C_DI_OC_HIGHPASS = 'highpass filter'; 
C_DI_OC_LOWPASS = 'lowpass filter';
C_DI_OC_EPOCH = 'Create epochs';
C_DI_OC_EPOCH_AUTO = 'auto bounds';
C_DI_OC_EPOCH_LIMITS = 'bounds:';
C_DI_OC_BASELINE = 'Baseline removal';
C_DI_OC_BASELINE_ALL = 'all';
C_DI_OC_BASELINE_LIMITS = 'limits';
C_DI_OC_THRESH = 'Threshold checking';
C_DI_OC_THRESH_LIMITS = 'limits';
C_DI_OC_DROPEPOCH = 'Drop epochs by hand';
C_DI_OC_ICA = 'Run ICA';
C_DI_OC_DROPCOMP = 'Drop components by hand';
C_DI_OC_SETTINGS = 'SETTINGS';
C_DI_OC_RESULT = 'RESULT';
C_DI_OC_SAVE = 'SAVE';

C_MSG_LETS_GO = 'these tasks will be executed if you press %s or %s';
C_MSG_BYFILES_ENDED = 'User mode running has finished with all tasks.';
C_MSG_NOPE = 'no tasks waiting';

C_MSG_IDLE = 'IDLE';
C_MSG_RUN = 'running';
C_MSG_AUTORUN = 'auto'; 
C_MSG_USERONLY = 'USER mode only';
C_MSG_STOPPING = 'Stops after current task';
C_MSG_INIT = 'INIT';
C_MSG_USERMODE_SKIPPED = '(USER mode tasks were skipped)';
C_MSG_AUTOMODE_SKIPPED = '(AUTO mode tasks were skipped)';
C_MSG_CANCELLED_TASK = 'DIDN''T RUN';
C_MSG_CANCELLED_MAINMSG = 'User abort, not every tasks completed';
C_MSG_ALLDONE = 'all tasks done (%04u/%02u/%02u-%02u:%02u:%02u)';
C_MSG_OPTABLES_LOADED = '(loaded %u OP-tables)';
C_MSG_TIMER_HLT = 'Processing of tasks suspended until %u:%u:%u (see Timer settings)';
C_MSG_TIMER_REST = '%u:%u:%u -- going on with tasks';
C_MSG_COOLDOWN_HLT = 'Processing of tasks suspended for %u:%u:%u';
C_MSG_COOLDOWN_REST = '%u:%u:%u -- going on with tasks';
C_MSG_SEARCH_HLT = 'Sleeping for %u:%u:%u (waiting for new tasks to become available)';

C_MSG_INCREASINGDITABLE = 'DITable extended: %u -> %u';
C_MSG_SEARCHDATSETSMULTIDIR = 'Cannot work with multiple working directories (%s,%s)!';
C_MSG_INVALIDFILENAME1 = 'Unmatching ''['' or '']'' in filename: %s. Cannot process.';
C_MSG_INVALIDFILENAME2 = 'Too many ( > 2 ) ''[...]'' blocks in filename: %s. Cannot process.';
C_MSG_INTERNAL_POSTFIX = ' --> Strange.';
C_MSG_CANNOT_PACK_FN_NO_SUBJECT = ['PackFilename() isn''t given ''subject''. (%s;%s;%s;%s;%s;%s;%s)' C_MSG_INTERNAL_POSTFIX];
C_MSG_CANNOT_PACK_SN_NO_SUBJECT = ['PackSetname() isn''t given ''subject''. (%s;%s;%s;%s;%s;%s;%s)' C_MSG_INTERNAL_POSTFIX];
C_MSG_ERRORCHK = 'Error running check run of plugin %s message: %s';
C_MSG_EXCEPTION_ONLY_CODE = '(error code: %u)';
C_MSG_NOPLUGIN_WARNING = 'Warning! Some plugins are missing, skipping those tasks.';
C_MSG_MULTI_WARNING = 'Warning! Processing multiple datasets requested from plugin unable to do that. Won''t run that.';
C_MSG_NOPLUGIN_ERROR = 'ERROR! Missing plugin: %s';
C_MSG_MULTI_ERROR = 'ERROR! Processing multiple datasets requested from plugin %s which is unable to do that.';
C_MSG_THIS_USERMODE_SKIPPED = '--USER mode--';
C_MSG_THIS_AUTOMODE_SKIPPED = '--AUTO mode--';
C_MSG_THIS_DONE = '(already done)';
C_MSG_THIS_NOPLUGIN = '(ERR: missing plugin)';
C_MSG_THIS_ERRORCHK = '(ERR: error while check run)';
C_MSG_THIS_ERRORRUN = '(ERR: error while running';
C_MSG_THIS_MULTIERROR = '(ERR: this plugin cannot handle multiple datasets at once)';
C_MSG_THIS_MUTEXERROR = '(mutex: another computer is currently working on it)';
C_MSG_THIS_EXOTIC = 'Strange error code: %u';
C_MSG_THIS_OPTMANAGEMENT = 'Scheduled for later';

C_MSG_PLUGIN_CANNOT_SELFCHECK = 'This plugin doesn''t support check mode! (Probably ill-formed output column in OP table.)'; % v0.1.022 (átfogalmazás)
C_MSG_NOPATHBUTFILES = 'Cannot determine path for selected files. Try choosing them one by one.!'; % v0.2.003 - C_MSG_INTERNAL_POSTFIX removed from the following lines
C_MSG_FSMUTEX_NOCREATE = 'Mutex (%s) hasn''t created!'; % v0.1.016
C_MSG_FSMUTEX_NOTEXIST = 'Mutex (%s) didn''t exist!';
C_MSG_FSMUTEX_NODELETE = 'Cannot delete mutex (%s)!';
C_MSG_FSMUTEX_NOCREATE2 = 'Cannot open/create mutex (%s)!';
C_MSG_FSMUTEX_NOOWNER = 'Mutex (%s) seems to be orphaned (no owner)!';
C_MSG_FSMUTEX_DIFFOWNER = 'Mutex has different owner error (mutexfile (%s) seems to be owned by %s)';

C_MSG_MTXCLEARED = '%u orphaned mutexes deleted';
C_MSG_MTXCLEARED2 = 'Warning! Removed %u orphaned mutexes. Check the following machines for possible crash: %s';

C_MSG_FLOGREINIT = 'Logging to file failed earlier. Trying to reinitialize.';
C_MSG_ELOGREINIT = 'Error logging failed earlier. Trying to reinitialize.';
C_MSG_XLOGREINIT = 'Debug logging failed earlier. Trying to reinitialize.';
C_MSG_NEWLOGFILE = 'Logfile: %s';
C_MSG_CANNOTCONDENSE = 'Error condensing logfiles: %s (file: %s)';

C_MSG_FILELOGERROR = 'Logfile (%s) open/write error: %s. Logging to file temporarily disabled.';
C_MSG_ERRORLOGERROR = 'Logfile (%s) open/write error: %s. Separate error logging temporarily disabled.';
C_MSG_XLOGERROR = 'Logfile (%s) open/write error: %s. Debug logging temporarily disabled.';
C_MSG_XLOGEXCEPTION = 'Debuglog exception: %s. Debug logging temporarily disabled.';
C_MSG_OPTABLEIOERR = 'OP table (%s) open/read error: %s. OP table skipped.';
C_MSG_OPTABLEERR = 'OP table structure error: less than 5 columns';

C_MSG_DSETLOGLINE1MEM = 'MATLAB uses %u MiB\t\tMax array %u MiB\t\tPhys avail %u MiB\t\t%u files opened';
C_MSG_DSETLOGLINE1NOMEM = '';	% fix(clock) % v0.1.019 - excess timestamp removed
C_MSG_DSETLOGLINE1B_UNMEASURABLE = 'Plugin time unmeasurable';
C_MSG_DSETLOGLINE1B = 'Plugin time %u:%.2f\t\t%.2f epochs/sec\t\t%.2f samples/sec';
C_MSG_DSETLOGLINE2 = '%s ----> %s ----> %s';	% infile,Func,outfile
C_MSG_DSETLOGLINE3S = 'arguments: %s';	% params
C_MSG_DSETLOGLINE3M = 'arguments: %s, together: %s';	% params,condslist
C_MSG_DSETLOGLINE3E = 'arguments: %s, ERROR: %s';	% params,error
C_MSG_DSETLOGLINE4 = '-----------------';

C_MSG_VLOGADD = 'DONE (code:%u) (%04u/%02u/%02u-%02u:%02u:%02u)';	% error, fix(clock)
C_MSG_LISTDITABLE_NOINFILE = ['Empty ''infile'' field in OP table!' C_MSG_INTERNAL_POSTFIX];
C_MSG_LISTDITABLE_INTERNAL_OUTPHASE = '<INTERNAL>';
C_MSG_PATHADDED = 'added to path: %s';

C_DISP_MAINWNDCLOSING = 'EEGbatch: closing main window';
C_DISP_EEGBATCHRESTART = 'EEGbatch: restart';

C_DISP_SETTINGSLOADED = 'Settings loaded from %s\n';
C_DISP_SETTINGSSAVED = 'Settings saved to %s\n';
C_MSG_LOADSETERR = 'Error loading settings from %s: %s';
C_MSG_LOADSETERR2 = 'Error while loading settings: %s';
C_MSG_SAVESETERR = 'Error saving settings to %s: %s';
C_MSG_SAVESETERR2 = 'Error while saving settings: %s'; 

C_MSG_FREQINROW_NOBANDFILE = 'DO_freqinrow: bandsetupfile (%s) not exists (message: %s)';
C_MSG_FREQINROW_NOCHANLOCS = 'No anterior-posterior/left-right analysis, since cannot find channel locations file! ';
C_MSG_FREQINROW_FILEERR1 = 'DO_freqinrow: Error while opening/reading spss header/output file (%s): %s';
C_MSG_FREQINROW_FILEERR2 = 'DO_freqinrow: Error while opening spss output file (%s): %s';
C_MSG_FREQINROW_CHANNELERR = 'DO_freqinrow: spectopo() found an unusal channel. Maybe signal channel forgot in there?';
C_MSG_FREQINROW_EMPTYBAND = 'DO_freqinrow: a spectopo() couldn''t find %s class wave (%.1f-%.1f)!';
C_MSG_FREQINROW = '%ux%u CSV-table written to %s';
C_DISP_FREQINROW_ANTEPOSTE = 'Ante/poste/left/right: %u/%u/%u/%u, precisely: ante: %s, poste: %s, left: %s, right: %s\n';
C_DISP_FREQINROW_PROCESSING = 'processing epoch %u/%u (file ETA: %02u:%02u:%02u)...\n';
C_DISP_FREQINROW_DONE = '%ux%u CSV-table written to %s\n';

C_MSG_FREQINROW_HEADER_PRJ = 'project';
C_MSG_FREQINROW_HEADER_SUBJ = 'subjectid';
C_MSG_FREQINROW_HEADER_SUBJGR = 'subjectgroup';
C_MSG_FREQINROW_HEADER_COND = 'condition';
C_MSG_FREQINROW_HEADER_EPOCHCOUNT = 'epochcount';
C_MSG_FREQINROW_HEADER_EPOCHNR = 'epoch_nr';
C_MSG_FREQINROW_HEADER_MARKED1 = 'marked_trigger';
C_MSG_FREQINROW_HEADER_MARKED2 = 'marked_man';
C_MSG_FREQINROW_HEADER_MARKED3 = 'marked_jp';
C_MSG_FREQINROW_HEADER_MARKED4 = 'marked_kurt';
C_MSG_FREQINROW_HEADER_MARKED5 = 'marked_thr';
C_MSG_FREQINROW_HEADER_MARKED6 = 'marked_con';
C_MSG_FREQINROW_HEADER_MARKED7 = 'marked_freq';

C_MSG_FREQINROW_HEADER_ANTE_PREFIX = 'ante_';
C_MSG_FREQINROW_HEADER_POSTE_PREFIX = 'poste_';
C_MSG_FREQINROW_HEADER_LEFT_PREFIX = 'left_';
C_MSG_FREQINROW_HEADER_RIGHT_PREFIX = 'right_';
C_MSG_FREQINROW_HEADER_CH_NR = 'ch%u';

C_MSG_SELECT = 'pop_select() done, EEGdata size: ';


C_MSG_PERFINDEXMUTEXERROR = 'Cannot reach file %s, used by another process/computer (persisting mutex error). Could be orphaned mutex? Consider running a mutex cleanup'; 
C_MSG_ERRORLOGMUTEXERROR = 'Cannot reach file %s, used by another process/computer (persisting mutex error). Could be orphaned mutex? Consider running a mutex cleanup'; 
C_MSG_XLOGMUTEXERROR = 'Cannot reach file %s, used by another process/computer (persisting mutex error). Could be orphaned mutex? Consider running a mutex cleanup'; 
C_MSG_CALCULATING_PI = 'Calculating PIndex...';
C_MSG_GOT_PI = 'Optimized percent: %u, PIndex: %u (MF:%u), %u entries in PIndex-table';
C_MSG_PI_OVR = 'Optimized percent: %u (manual override)';

C_MSG_INTERRORSD = ['STOPPED: unexpected error during searching for tasks: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_INTERRORPR = ['STOPPED: unexpected error during execution: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_INTERRORLDI = ['STOPPED: unexpected error during listing tasks: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_ERRORSD = 'STOPPED: error during searching for tassk: %s';
C_MSG_ERRORPR = 'STOPPED: error during execution: %s';

C_DI_PLUGINEDITOR_CAPTION = 'EEGbatch Plugin editor';
C_DI_PLUGINEDITOR_PLUGINNAME = 'plugin name:';
C_DI_PLUGINEDITOR_PLUGINPARAMS = 'arguments:';
C_DI_PLUGINEDITOR_SAVE = 'SAVE';
C_DI_PLUGINEDITOR_FUNCTIONFORMAT = 'function [funcres, EEG, logstr] = %s(dataset,EEG,wtd%s)';
C_DI_HELP1 = { ...
    'Some help:', ...
    '', ...
    'dataset.FN........filename', ...
    'dataset.Prj.......projectname', ...
    'dataset.SubjGr....subject group', ...
    'dataset.Subj......subject id', ...
    'dataset.Cond......condition', ...
    '(if it can handle multiple datasets, ', ...
    'then dataset(i).FN etc.)'};

C_DI_HELP2 = { ...
    'EEG..........EEGLAB struct', ...
    'wtd..........''run'' or ''check'' (the latter should be implemented only if plugin checks itself by some non-standard whether it''s run before)', ...
    'funcres.......status result, <0: error, >0: OK'};

C_DI_PE_BODY = {'% here comes plugin code', ...
		'if strcmpi(wtd,''run'')', ...
		 '', ...
		'    % actual code', ...
		'', ...
		'end;'};

C_DI_PE_POSTFIX = 'end';
%
%
%
% ----------------- CONSTANTS ---------------------
%
%
%
% file format consts
C_OPTABLE_BEGIN = '%%% OPTABLE BEGIN %%%';
C_OPTABLE_END = '%%% OPTABLE END %%%';
C_OPTABLE_POSTFIX = '_OPTABLE.txt';
C_OPTABLE_BACKUP = '_OPTABL~.txt';
C_OPTABLE_FILENAME_FORMAT_WO_SUBJGR = ['[%s]' C_OPTABLE_POSTFIX];
C_OPTABLE_FILENAME_FORMAT = ['[%s][%s]' C_OPTABLE_POSTFIX];
C_FUNCID_USER = 'USER_';
C_FUNCID_MULTI1 = 'MULTI_';
C_FUNCID_MULTI2 = '_MULTI_';
C_FUNCID_DONTOPEN = 'dontopen';
C_LOGTOFILE_FILENAME_FORMAT = 'EEGbatch_log%u.txt';
C_LOGTOFILE_FILENAME_MASK = 'EEGbatch_log*.txt';
C_LOGTOFILE_CONDENSE_MUTEX = 'EEGbatch#condensinglogfiles.lock';
C_LOGTOFILE_CONDENSE_FILENAME_FORMAT = 'EEGbatch#log#%04u%02u%02u.txt';
C_ERRLOG_FILENAME_FORMAT = 'EEGbatch_errorlog.txt';
C_XLOG_FILENAME_FORMAT = 'EEGbatch_debuglog.txt';
C_LOGTOFILE_MSG_FORM = '%04u/%02u/%02u-%02u:%02u:%02u\t%s\n';
C_ERRLOG_MSG_FORM = '%04u/%02u/%02u-%02u:%02u:%02u\t%s\t%s\n';
C_XLOG_MSG_FORM = '%04u/%02u/%02u-%02u:%02u:%02u\t%s\t%s\n';
C_DROPEPOCH_MAKEAUTO_FILENAME_FORMAT = '[%s][%s].DROPEPOCHauto.txt'; % Prj, SubjGr
C_DROPEPOCH_REJECTSTRUCT_FILENAME_FORMAT = '[%s][%s][%s][%s].DROPEPOCHauto.reject.mat'; % Prj, SubjGr, Subj, Cond
C_DROPCOMP_MAKEAUTO_FILENAME_FORMAT = '[%s][%s].DROPCOMPauto.txt'; % Prj, SubjGr
C_IDROPCOMP_MAKEAUTO_FILENAME_FORMAT = C_DROPCOMP_MAKEAUTO_FILENAME_FORMAT;
C_AUTODROPCOMP_MAXDISTANCE = 0.1;
C_AUTODROPCOMP_FACTOR_INVARIANT = 1;

C_FREQINROW_ONEFILE_OUTFN = 'spssout_%s.csv'; % dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond
C_FREQINROW_ONEFILE_TESTFN = 'spssout_ready [%s][%s][%s][%s]'; % dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond
C_FREQINROW_ONEFILE_HDRFN = 'spssout_%s.csv'; % dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond

C_FREQINROW_MULTIFILE_OUTFN = 'spssout [%s][%s][%s][%s].csv';
C_FREQINROW_MULTIFILE_TESTFN = C_FREQINROW_MULTIFILE_OUTFN;
C_FREQINROW_MULTIFILE_HDRFN = 'spssout header.csv';

C_FREQINROW_DEFAULTBANDS = ...
		{'Delta','Theta','Alfa1','Alfa2','Beta1','Beta2','Gamma'; ...
		0.5,4,8, 11,13,25,35; ...
		4,  8,11,13,25,35,50};	
% original C_FREQINROW_xxx constants		
% C_FREQINROW_ELECTRODE_OUTOFHEAD = 1.1;			% if distance > this, the electrode is not seated on the head
% C_FREQINROW_ELECTRODE_INVALID = 0.1;				% if distance < this, the electrode has an invalid location
% C_FREQINROW_ELECTRODE_ANTE = 0.1;					% ante: X>0
% C_FREQINROW_ELECTRODE_POSTE = -0.1;				% poste: X<0
% C_FREQINROW_ELECTRODE_LEFT = 0.1;					% left: Y>0
% C_FREQINROW_ELECTRODE_RIGHT = -0.1;				% right: Y<0

% new C_FREQINROW_xxx % v0.2.003
C_FREQINROW_ELECTRODE_OUTOFHEAD = 0.11;				% if distance > this, the electrode is not seated on the head
C_FREQINROW_ELECTRODE_INVALID = 0.09;				% if distance < this, the electrode has an invalid location
C_FREQINROW_ELECTRODE_SEPARATOR = 1e-5;
C_FREQINROW_ELECTRODE_ANTE = C_FREQINROW_ELECTRODE_SEPARATOR;					% ante: X>0
C_FREQINROW_ELECTRODE_POSTE = -C_FREQINROW_ELECTRODE_SEPARATOR;					% poste: X<0
C_FREQINROW_ELECTRODE_LEFT = C_FREQINROW_ELECTRODE_SEPARATOR;					% left: Y>0
C_FREQINROW_ELECTRODE_RIGHT = -C_FREQINROW_ELECTRODE_SEPARATOR;					% right: Y<0

C_FREQINROW_OLDMARK_ARTEFACT = 0;

C_ERRLOG_MUTEX_MAXWAIT = 60;
C_XLOG_MUTEX_MAXWAIT = 60;

% CONSTANTS - Performance Index component
C_PI_DATNAME = 'PERFIND.MAT';						% Name of PI component's data file, one in each workdir
C_PI_RECALC_INTV = 30;								% Time in days between two performance selftests
C_PI_ZOMBIE_INTV = 7;								% A computer listed in PERFIND.MAT after this much days of													% inactivity is considered to not participate in that work, and...
C_PI_DEAD_INTV = 30;								% after this number of days, the computer is deleted by other computers
C_PI_MUTEX_MAXWAIT = 60;							% Maximum wait time, in seconds for the PERFIND.MAT to be released
													% by other computers
% for VAR_PerfInd_MutexEnabled or VAR_PI_MutexEna, see settings section above
C_PI_AVGFACTOR1 = 1;								% These two are coefficients for the weighted average of recent 
C_PI_AVGFACTOR2 = 1;								% performance selftest and ones in the past. See there.
C_PI_STARTMEASURE_FACTOR = 100000000;				% Default length of loop for performance test
C_PI_MF_MULTIPLIER = 10;							% Length multiplier if the default loop length is unmeasurably fast

% CONSTANTS - OP, DI and UNDO table declaration, initial sizes
% for the initial reservation only, nothing terrible happens if we reach/exceed these
C_OPTABLES_NR_DEFAULT = 50;                         % we expect to find at most this many OP-table files
C_OPTABLES_LINENR_DEFAULT = 50;						% with this many lines (commands) in them
C_DITABLES_LINENR_DEFAULT = 250;					% all commands in all OP-tables applied to all appropriate files
C_UNDO_SIZE_TABLE_EDITOR = 50;						% This number of steps can are expected in the OP-table editor

% CONSTANTS - More
C_ICA_USERABORT_CODE = -131344;						% This result code identifies the case when the user press the
													% "Interrupt" button while running ICA. 
C_VLOG_CLC_LIMIT = 5000;							% we clear the visual log when if it had more than this many lines
C_XLOG_SIZE_LIMIT = 10*1024*1024;					% if debug log reaches 10 MiB, we clear it and start it all over again
C_LOSTMUTEX_DAYS = 2;								% a mutex lock file considered to be orphaned after this
C_MAKESOMENOISE_FREQ = [2000 0 2000 0];				% Sound played when USER mode running is over. Format:
C_MAKESOMENOISE_PATTERN = [.1 .3 .1 .3];			% freq: [freq1 freq2 ...], pattern: [length1 length2 ...]
C_MAKESOMENOISE_VOLUME = 0.3;						% it was originally fixed to 1
C_MAINWINDOW_FORMAT_SNGL = 'EEGbatch %s';			% Main window title format (if this is the only instance)
C_MAINWINDOW_FORMAT_MULT = 'EEGbatch %s (%u)';		% (if other EEGbatch instances are running)
C_BuiltInFunc = {	'DO_PREP19', ...
					'DO_EVENTS', ... 
					'DO_EPOCHS', ... 
					'DO_BASELINE', ... 
					'DO_HIGHPASS', ... 
					'DO_LOWPASS', ... 
					'DO_MULTI_ICA', ... 
					'DO_THRESH', ... 
					'USER_DROPEPOCH', ... 
					'USER_DROPCOMP', ... 
					'DO_PREPEDF', ... 
					'DO_ADDEVENTCH', ...
					'AUTO_DROPEPOCH', ...
					'AUTO_DROPCOMP', ...
					'DO_IDROPCOMP', ...
					'DO_select', ...
					'DO_freqinrow'};

% CONSTANTS - opStatus codes
OPS_STOP = 0;										% OPS: opStatus
OPS_TERMINATING = -1;
OPS_RUN = 1;
OPS_AUTO = 2;
OPS_USERONLY = 3;
OPS_INIT = 1111;
PDI_USERONLY = 2; % v0.2.002
PDI_USERMODE = 1;									% PDI: ProcessDITable
PDI_AUTOMODE = 0;
SDS_BYFILES = 1;									% SDS: SearchDatasets
SDS_BYDIR = 0;

DIS_READY = 1;										% DIS: DITableStatus
DIS_ALREADYDONE = 0;
DIS_DONE = 0;
DIS_NOPLUGIN = -1;
DIS_ERRORCHK = -2;
DIS_ERRORRUN = -3;
DIS_MULTIERROR = -4;
DIS_MUTEXERROR = -5;
DIS_OPTMANAGEMENT = -6;
DIS_EXTERNALFACTOR = 16;
%
%
%
% ---------------- VARIABLES ----------------------
%
%
%
selectByFile = 0;
logFilename = '';
errorLogname = '';
xLogname = '';
glob_findin = '';
mainPERFtable = [];
myPI = 0;
opStatus = 0;
waitTimer = 0;
DIthingstodo = 0; 
DIthingsdone = 0;
round_start = 0;
cooldown_rs = zeros(1,6);
pathmanTable = cell(1,1);
opt_ratio_perf = 0;
mainwindowname = '';
MainDialog = 0; % MainDialog forward, see waitfor(MainDialog)
LogControl = 0; % LogControl forward, for vLog etc.
LbETA = 0;
LbOptPercent = 0;
OptSlider = 0;
%
%
%
% ------ INITIALIZING OPTABLE&DITABLE -------------
%
%
%
OPTableSize = 0; OPTableAllLines = 0; %TODO: OPTableAllLines gets updated only in LoadOPTables, not in e.g. op-table editor
OPTableNames(C_OPTABLES_NR_DEFAULT) = struct('FileName','','Prj','','SubjGr',''); 
OPTables(C_OPTABLES_NR_DEFAULT,C_OPTABLES_LINENR_DEFAULT) = struct('InMask','','Conds',{{}},'Func','','Multi',0,'AutoFN',0,'Params','','OutMask',{{}},'eid',[],'dontopen',0);
DITableSize = 0;
DITable(C_DITABLES_LINENR_DEFAULT) = struct('Status',1, ...
                                        'InFile',{{}}, ...
                                        'Prj',{{}}, ...
                                        'SubjGr',{{}}, ...
                                        'Subj',{{}}, ...
                                        'Cond',{{}}, ...
                                        'Func','', ...
                                        'Multi',0, ...
                                        'AutoFN',0, ...
                                        'Params','', ...
                                        'OutFile',{{}}, ...
                                        'logpos',[], ... % **A191xX**
                                        'mtxid',{{}}, ... % v0.1.016 
										'dontopen',0); % v0.2.001

%
%
%
% ----- SETTINGS & PATH MANAGEMENT ----------------
%		function [printout] = ListSettings
%		function [OK] = LoadSettings(fn)
%		function [OK] = SaveSettings(fn)
%		function [added] = PathMan(dirpath)

C_SETTINGS = { ...
{'MATLAB version', 'version'}, ...
{'EEGLAB version', 'eeg_getversion'}, ...
{'EEGbatch version', 'C_EEGBATCH_VER'}, ...
'VAR_MutexEnabled', ...
'VAR_ErrorLog_MutexEnabled', ...
'VAR_PerfInd_MutexEnabled', ...
'VAR_ExtendedLog_MutexEnabled', ...
'VAR_DefaultPluginDir', ...
'VAR_DefaultDir', ...
'VAR_AutoSelect', ...
'VAR_AutoRun', ...
'VAR_PerfInd_Enabled', ...
'VAR_PerfInd_HideMe', ...
'VAR_PerfInd_NoRecalc', ...
'VAR_LogToFile', ...
'VAR_ErrorLog', ...
'VAR_SeparateLogFiles', ...
'VAR_ExtendedLog', ...
'VAR_LogMemState', ...
'VAR_DatasetLogging', ...
'VAR_RunTimer', ...
'VAR_RunTimerStart', ...
'VAR_RunTimerEnd', ...
'VAR_WeekendRun', ...
'VAR_CooldownTimer_Enabled', ...
'VAR_CooldownTimer_Interval', ...
'VAR_CooldownTimer_Duration', ...
'VAR_SearchAgainWait', ...
'VAR_OptRatio_Roundup', ...
'VAR_OptRatio_Override', ...
'VAR_ThrowExceptions', ...
'VAR_DatasetLogging_UsePopcomments', ...
'VAR_DatasetLogging_UseNewVar', ...
'VAR_DropComp_MakeAuto', ...
'VAR_IDropComp_MakeAuto', ...
'VAR_DropComp_PrtScr', ...
'VAR_DropEpoch_EEGLAB', ...
'VAR_DropEpoch_MakeAuto', ...
'VAR_DropEpoch_SaveRejectStruct', ...
{'Sytem', 'computer'}, ...
{'Memory MATLAB Mb', ' floor(userview.MemUsedMATLAB / 1024 / 1024) '}, ...
{'Memory continuous Gb', 'userview.MaxPossibleArrayBytes / 1024 / 1024 / 1024'}, ...
{'Memory fragmentation', 'userview.MemAvailableAllArrays-userview.MaxPossibleArrayBytes'}, ...
{'Memory address space Gb', 'systemview.VirtualAddressSpace.Total / 1024 / 1024 / 1024'}, ...
{'Memory system avail Gb', 'systemview.SystemMemory.Available / 1024 / 1024 / 1024'}, ...
{'Memory physical total Gb', 'systemview.PhysicalMemory.Total / 1024 / 1024 / 1024'}, ...
{'Memory physical avail Gb', 'systemview.PhysicalMemory.Available / 1024 / 1024 / 1024'}, ...
'C_AUTODROPCOMP_MaxDistance', ...
'C_LostMutexDays', ...
'C_ERRLOG_MutexMaxWait', ...
'C_PI_DatName', ...
'C_PI_Recalc_Intv', ...
'C_PI_Zombie_Intv', ...
'C_PI_Dead_Intv', ...
'C_PI_MutexMaxWait', ...
'C_PI_AvgFactor1', ...
'C_PI_AvgFactor2', ...
'C_PI_StartMeasureFactor', ...
'C_PI_MFMultiplier', ...
'C_OPTableSizeDefault', ...
'C_OPTableNrDefault', ...
'C_DITableSizeDefault', ...
'C_UndoTableSizeDefault', ...
'logfilename', ...
'errorlogname', ...
'opt_ratio_perf', ...
'VAR_DISP', ...
'VAR_DISPmain', ...
'VAR_LogPluginBenchmark', ...
'VAR_ProfilingEnabled', ...
'VAR_DetailedExceptions', ...
'VAR_StrictFileRules' };

	function [printout] = ListSettings
		printout = [sprintf('%s\n','---SETTINGS&SYSTEM INFO---')];
		[userview systemview] = memory;
		for i = 1:numel(C_SETTINGS)
			if iscell(C_SETTINGS{i})
				title = C_SETTINGS{i}{1};
				val = eval(C_SETTINGS{i}{2});
			else
				title = C_SETTINGS{i};
				val = eval(C_SETTINGS{i});
			end;
			if isstr(val)
				checkfor = val;
			elseif numel(val) > 1
				checkfor = val(1);
			else
				checkfor = val;
			end;
			if isnumeric(checkfor)
				if floor(checkfor) == checkfor
					formatstr = '%i';
				else
					formatstr = '%f';
				end;
			else
				formatstr = '%s';
			end;
			printout = [printout title ': ' sprintf(formatstr,val)];
			if mod(i,3) == 0
				printout = [printout sprintf('\n')];
			else
				printout = [printout sprintf('\t')];
			end;
		end;
		printout = [printout sprintf('\n%s\n','--------------------------')];
	end % func ListSettings
	
	
	function [OK] = LoadSettings(fn)
	
		OK = 1;
		if ~exist(fn,'file')
			OK = -1;
			return;
		end;
		[sfh msg] = fopen(fn,'r');
		if sfh < 0
			OK = -2;
			aLog(sprintf(C_MSG_LOADSETERR,fn,msg));
			return;
		end;
		
		try
			settings_ev = '';
			s = fgets(sfh);
			while ~isnumeric(s)
				settings_ev = [settings_ev s];
				s = fgets(sfh);
			end;
		catch exception
			fclose(sfh); sfh = 0;
			OK = -2;
			aLog(sprintf(C_MSG_LOADSETERR,fn,exception.message));
			if VAR_throwexceptions, rethrow(exception); end;
			return;
		end;
		if sfh > 0
			fclose(sfh);
		end;
		
		try
			eval(settings_ev);
		catch exception
			aLog(sprintf(C_MSG_LOADSETERR2,exception.message));
			if VAR_throwexceptions, rethrow(exception); end;
		end;
			
		if VAR_DISPmain, fprintf(C_DISP_SETTINGSLOADED,fn); end;
	
	end % func LoadSettings
	
	function [OK] = SaveSettings(fn)

		if ~strcmpi(glob_findin,'')
			VAR_DefaultDir = glob_findin;
		end;
		OK = 1;
		try 
			printout = '';
			for i = 1:numel(C_SETTINGS)
				if ~iscell(C_SETTINGS{i}) & isstr(C_SETTINGS{i}) & ...
					(numel(C_SETTINGS{i}) > 3) & strcmpi(C_SETTINGS{i}(1:4),'VAR_')
					title = C_SETTINGS{i};
					val = eval(C_SETTINGS{i});
					if isstr(val)
						startwith = '''';
						endwith = '''';
						checkfor = val;
					elseif numel(val) > 1
						startwith = '[';
						endwith = ']';
						checkfor = val(1);
					else
						startwith = '';
						endwith = '';
						checkfor = val;
					end;
					if isnumeric(checkfor)
						if floor(checkfor) == checkfor
							formatstr = '%i ';
						else
							formatstr = '%f ';
						end;
					else
						val = strrep(val,'\','\\'); % escaping all '\'
						formatstr = '%s'; 
					end;
					
					val_s = sprintf(formatstr,val);
					
					printout = [printout sprintf('%s = %s%s%s; \n',title,startwith,val_s,endwith)];
				end; % if
			end; % for
        catch exception
			OK = -2;
			aLog(sprintf(C_MSG_SAVESETERR2,exception.message));
			return;
		end;
		
		[sfh msg] = fopen(fn,'w');
		if sfh < 0
			OK = -2;
			aLog(sprintf(C_MSG_SAVESETERR,fn,msg));
			return;
		end;
		
		try
			fprintf(sfh,printout);
		catch exception
			fclose(sfh); sfh = 0;
			OK = -2;
			aLog(sprintf(C_MSG_SAVESETERR,fn,exception.message));
			if VAR_throwexceptions, rethrow(exception); end;
			return;
		end;
		if sfh > 0
			fclose(sfh);
		end;			
		
		if VAR_DISPmain, fprintf(C_DISP_SETTINGSSAVED,fn); end;
	end % func SaveSettings
	
    function [added] = PathMan(dirpath)
        added = 0;
        if strcmpi(dirpath,'')
            return;
        end;
        if (~strcmpi(dirpath,VAR_DefaultPluginDir)) && (~strcmpi(VAR_DefaultPluginDir,''))
            added = PathMan(VAR_DefaultPluginDir);
        end;
        found = 0;
        for i = 1:numel(pathmanTable)
            if strcmpi(pathmanTable{i},dirpath)
                found = 1;
            end;
        end;
        if ~found
            added = added + 1;
            addpath(dirpath);
            pathmanTable{numel(pathmanTable)+1} = dirpath;
            aLog(sprintf(C_MSG_PATHADDED,dirpath));
        end;
    end
	
%
%
%
% ---------------- ????????? ----------------------
%
%
%
	function [result] = DIS2str(status)
		if isempty(status)
			result = '<no status code>';
		else
			switch status
				case DIS_READY
					result = 'ready-to-run';
				case DIS_DONE
					result = 'done';
				case DIS_NOPLUGIN
					result = 'plugin missing :(';
				case DIS_ERRORCHK
					result = 'checking error :(';
				case DIS_ERRORRUN
					result = 'error :(';
				case DIS_MULTIERROR
					result = 'error: multiple datasets :(';
				case DIS_MUTEXERROR
					result = 'mutexed-by-others';
				case DIS_OPTMANAGEMENT
					result = 'optimalized-runlater';
				otherwise
					result = sprintf('DITable status: %u',status);
			end;
		end;
	end
	
	function [result] = OPS2str(status)
		if isempty(status)
			result = '<no status code>';
		else
			switch status
				case OPS_STOP
					result = '[STOP]';
				case OPS_TERMINATING
					result = '[STOP pressed]';
				case OPS_RUN
					result = '[RUN]';
				case OPS_AUTO
					result = '[AUTORUN]';
				case OPS_USERONLY
					result = '[USERONLY]';
				case OPS_INIT
					result = '[INIT]';
				otherwise
					result = '??????';
			end;
		end;
	end
	
	function xLogDITable
		return; %TODO: temporarily disabled % v0.2.003
		C_MSG_DITABLESTART = 'Listing DI table, status %s, # of elements: %u, allocated %u, gonna list the first %u lines';
		C_MSG_DITABLEENDSHERE = '----- DItable ends here -----';
		C_MSG_DITABLEEMPTY = '???? DITable is empty. Strange';
		function [result] = yesno(value)
			if isempty(value)
				result = '---';
			elseif value
				result = 'ON ';
			else
				result = 'OFF';
			end;
		end
		if VAR_ExtendedLog
		
			if ~isempty(DITable)
				itemstolist = min(DITableSize+5,numel(DITable));
				xLog(sprintf(C_MSG_DITABLESTART,OPS2str(opStatus),DITableSize,numel(DITable),itemstolist));
				for i = 1:itemstolist
					if ~isempty(DITable(i).InFile) && isstr(DITable(i).InFile{1})
						s1 = DITable(i).InFile{1};
					else
						s1 = '<no infile>';
					end;
					if ~isempty(DITable(i).OutFile) && isstr(DITable(i).OutFile{1})
						s2 = DITable(i).OutFile{1};
					else
						s2 = '<no outfile>';
					end;
					if ~isempty(DITable(i).mtxid) && isstr(DITable(i).mtxid{1})
						s3 = DITable(i).mtxid{1};
					else
						s3 = '<no mtxid>';
					end;
					if ~isempty(DITable(i).Prj) && isstr(DITable(i).Prj{1})
						z1 = DITable(i).Prj{1};
					else
						z1 = '<no prj>';
					end;
					if ~isempty(DITable(i).SubjGr) && isstr(DITable(i).SubjGr{1})
						z2 = DITable(i).SubjGr{1};
					else
						z2 = '<no subjgr>';
					end;
					if ~isempty(DITable(i).Subj) && isstr(DITable(i).Subj{1})
						z3 = DITable(i).Subj{1};
					else
						z3 = '<no subj>';
					end;
					if ~isempty(DITable(i).Cond) && isstr(DITable(i).Cond{1})
						z4 = DITable(i).Cond{1};
					else
						z4 = '<no cond>';
					end;
					if ~isempty(DITable(i).Func) && isstr(DITable(i).Func)
						z5 = DITable(i).Func;
					else
						z5 = '<no func>';
					end;
					if ~isempty(DITable(i).Params) && isstr(DITable(i).Params)
						z6 = DITable(i).Params;
					else
						z6 = '<no params>';
					end;
						
					xLog(sprintf('%20s\t %20s\t %20s\t %20s\t %10s\t %20s\t %20s\t %s/%s/%s/%u %100s\t %100s\t %100s\t', ...
						DIS2str(DITable(i).Status), ...
						z1, z2, z3, z4, ...
						z5, z6, ...
						yesno(DITable(i).AutoFN),yesno(DITable(i).Multi),yesno(DITable(i).dontopen),DITable(i).logpos, ...
						s1,s2,s3));
						
					for j = 2:numel(DITable(i).InFile)
						if j == 2
							xLog(sprintf('\t\tmore infiles:'));
						end;
						xLog(sprintf('\t\t\t%s',DITable(i).InFile{j}));
					end;
					for j = 2:numel(DITable(i).OutFile)
						if j == 2
							xLog(sprintf('\t\tmore outfiles:'));
						end;
						xLog(sprintf('\t\t\t%s',DITable(i).OutFile{j}));
					end;
					for j = 2:numel(DITable(i).mtxid)
						if j == 2
							xLog(sprintf('\t\tmore mtxid''s:'));
						end;
						xLog(sprintf('\t\t\t%s',DITable(i).mtxid{j}));
					end;
					if i == DITableSize
						xLog(C_MSG_DITABLEENDSHERE);
					end;
				end; % for
			else
				xLog(C_MSG_DITABLEEMPTY);
			end;
		
		end; % if VAR_
	end % func xLogDITable
	
%
%
%
% --------------- main dialog ---------------------
%		function dialog_create(var_as,var_ar) % params: AutoSelect, AutoRun
%		function waittimer_nope_callback(obj, event)
%		function dialog_OPTableEditor()	
%		function [res] = SaveOPTable(path, prjname, subjgr, OPTableData)	
%		function [res] = SaveOPTableFN(fn, OPTableData)
%		function dialog_PluginEditor()
	
    function dialog_create(var_as,var_ar) % params: AutoSelect, AutoRun
        % find other instances and make unique main window title
        defaulttitle = sprintf(C_MAINWINDOW_FORMAT_SNGL,C_EEGBATCH_VER);
        other_inst = findall(0,'TAG','EEGbatch');
        if numel(other_inst) == 0
            mainwindowname = defaulttitle;
        else
            mainwindowname = sprintf(C_MAINWINDOW_FORMAT_MULT,C_EEGBATCH_VER,numel(other_inst)+1);
        end;
        
        MainDialog = dialog('WindowStyle','normal','Name',mainwindowname);
        set(MainDialog,'TAG','EEGbatch');
        siz = get(MainDialog,'Position');
        siz(2) = siz(2) - 100;
        siz(4) = siz(4) + 100;
		siz(3) = siz(3) + 100; % v0.1.017
        set(MainDialog,'Position',siz);
        GlobSettings = uipanel(MainDialog,'Position',[0 0 .30 1],'Title',C_DI_SETTINGS);
        
        uicontrol(GlobSettings,'Style','text','Position',                           [5 490 180 15],'String',C_DI_OPDIR);
        EdPath = uicontrol(GlobSettings,'Style','edit','Position',                  [5 470 160 20]);
        BrowseDirBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',      [165 470 20 20],'String','...','callback',@BrowseDir_Callback);
		RefreshDirBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',		[165 455 20 15],'string','R','callback',@RefreshDir_Callback);
        uicontrol(GlobSettings,'Style','text','Position',                           [25 455 140 15],'String',C_DI_OR);
        BrowseFilesBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',    [5 435 180 20],'String',C_DI_ICHOOSE,'callback',@BrowseFiles_Callback);
        LbSelected = uicontrol(GlobSettings,'Style','text','Position',              [5 420 180 15],'String','');
        CboxLogToFile = uicontrol(GlobSettings,'Style','checkbox','Position',       [5 400 120 20],'string',C_DI_LOGTOFILE,'Value',1);
        CboxNetworkMode = uicontrol(GlobSettings,'Style','checkbox','Position',     [5 380 120 20],'string',C_DI_NETWORKMODE);
		LbETA = uicontrol(GlobSettings,'Style','text','Position',					[130 380 55 40],'string',C_DI_ETA_RESET,'HorizontalAlignment','center');
        
        StartStopBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',      [5 320 90 45],'String',C_DI_START,'callback',@Operator_Callback);
		UserOnlyBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',      [95 320 90 45],'String',C_DI_USERONLY,'callback',@Operator_Callback); % yes it's got the same function
		
        
        
        CboxRunTimer = uicontrol(GlobSettings,'Style','checkbox','Position',        [5 290 85 20],'string',C_DI_TIMER,'Value',0, ...
            'callback',@CboxRunTimer_callback);
        CboxWeekend = uicontrol(GlobSettings,'Style','checkbox','Position',         [90 290 90 20],'string',C_DI_WEEKENDRUN);
        EdRunTimerStart = uicontrol(GlobSettings,'Style','edit','Position',         [5 270 40 20],'string','22');
        LbTimer1 = uicontrol(GlobSettings,'Style','text','Position',                [45 270 10 20],'string','-');
        EdRunTimerEnd = uicontrol(GlobSettings,'Style','edit','Position',           [55 270 40 20],'string','07');
        LbTimer2 = uicontrol(GlobSettings,'Style','text','Position',                [95 270 90 20],'string',C_DI_UNTILTHIS);
        CboxCooldownTimer = uicontrol(GlobSettings,'Style','checkbox','Position',   [5 250 180 20],'string',C_DI_COOLDOWN,'Value',0);
        
        AutoRunBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',        [5 200 180 45],'String',C_DI_AUTOMODE,'callback',@AutoRun_Callback);
        
        uicontrol(GlobSettings,'Style','text','Position',                           [5 170 75 20],'string',C_DI_OPTPERCENT, ...
            'HorizontalAlignment','left');
        LbOptPercent = uicontrol(GlobSettings,'Style','text','Position',            [85 170 30 20],'string','0');
        CboxOPTAuto = uicontrol(GlobSettings,'Style','checkbox','Position',         [125 170 55 20], ...
            'string',C_DI_OPTPERCENT_AUTO,'callback',@OptPercentAuto_Callback,'Value',1);
        OptSlider = uicontrol(GlobSettings,'Style','slider','Position',             [5 150 180 20], ...
            'Min',0,'Max',100,'SliderStep',[.01 .3],'Value',0,'Enable','off', ...
            'callback',@OptSlider_callback);
        
        uicontrol(GlobSettings,'Style','text','Position',                           [5 120 180 15],'string',C_DI_COMMONPLUGINS);
        EdCommonPlugins = uicontrol(GlobSettings,'Style','edit','Position',         [5 100 160 20],'string','');
        CPluginsBrowseBtn = uicontrol(GlobSettings,'Style','pushbutton','Position', [165 100 20 20],'string','...','callback',@CPluginsBrowse_Callback);
        
        
        LogPanel = uipanel(MainDialog,'Position',[.30 0 .70 1],'Title',C_DI_MESSAGES);
        LogControl = uicontrol(LogPanel,'style','listbox','max',2,'position',[5 5 450 500]);
        
        CleanupBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',     	   [5 75 85 22],'String',C_DI_CLEANUP, ...
            'Enable','on','callback',@Cleanup_Callback);
        OPTableEditorBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',     [5 53 85 22],'String',C_DI_OPTABLE_EDITOR, ...
            'Enable','on','callback',@OPTableEditor_Callback);
        PluginEditorBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',      [5 30 85 22],'String',C_DI_PLUGIN_EDITOR, ...
            'Enable','on','callback',@PluginEditor_Callback); % v0.1.025
        ShowComputersBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',     [100 75 85 22],'String',C_DI_SHOW_COMPUTERS, ...
            'Enable','on','callback',@ShowComputers_Callback);
		SaveSettingsBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',      [100 53 85 22],'String',C_DI_SAVE_SETTINGS, ...
            'Enable','on','callback',@SaveSettings_Callback); % v0.1.025
		RestartBtn = uicontrol(GlobSettings,'Style','pushbutton','Position',		   [100 30 85 22],'String',C_DI_RESTART, ...
            'Enable','on','callback',@Restart_Callback); % v0.2.003
        
        LbStatus = uicontrol(GlobSettings,'Style','text','Position',                [5 5 180 15],'String',C_MSG_IDLE, ...
            'Foregroundcolor','red');

        SetDialogProps;
        
        % main dialog ready, check for parameters
        
        if var_ar % check 1
            var_as = 1;
        end; % AutoRun is meaningless w/o AutoSelect
        
        if strcmpi(VAR_DefaultDir,'') % check 2
            var_as = 0;
            var_ar = 0;
        end; % AutoRun/AutoSelect are absurd w/o having a default dir
        
        if var_as % logging first
            vLog(sprintf(C_MSG_AUTOSELECT_ACTIVE,VAR_DefaultDir));
        end;
        if var_ar
            vLog(C_MSG_AUTORUN_ACTIVE);
        end;
        
        if var_as
            SelectDir(VAR_DefaultDir);
        end;
        
        if var_ar
            AutoRun_Callback(AutoRunBtn,0,0);
        end;
        
        function StartStop(ModeSel)
            % StartStop update (v0.1.011) OPS_INIT + C_MSG_INIT
            % OPS_INIT speciality: opStatus hasn't changed since it's
            % not a valid opStatus value
            switch ModeSel
                case OPS_STOP % IDLE
                    set(StartStopBtn,'String',C_DI_START);
					set(UserOnlyBtn,'String',C_DI_USERONLY);
                    set(AutoRunBtn,'String',C_DI_AUTOMODE);
                    set(LbStatus,'String',C_MSG_IDLE);
                case OPS_RUN % RUNNING
                    set(StartStopBtn,'String',C_DI_STOP);
					set(UserOnlyBtn,'String',C_DI_STOP);
                    set(AutoRunBtn,'String',C_DI_STOP);
                    set(LbStatus,'String',C_MSG_RUN);
                case OPS_AUTO % RUNNING AUTO
                    set(StartStopBtn,'String',C_DI_STOP);
					set(UserOnlyBtn,'String',C_DI_STOP);
                    set(AutoRunBtn,'String',C_DI_STOP);
                    set(LbStatus,'String',C_MSG_AUTORUN);
				case OPS_USERONLY % USER ONLY
                    set(StartStopBtn,'String',C_DI_STOP);
					set(UserOnlyBtn,'String',C_DI_STOP);
                    set(AutoRunBtn,'String',C_DI_STOP);
                    set(LbStatus,'String',C_MSG_USERONLY);
                case OPS_TERMINATING % TERMINATING
                    set(StartStopBtn,'String',C_DI_STOP);
                    set(AutoRunBtn,'String',C_DI_STOP);
                    set(LbStatus,'String',C_MSG_STOPPING);
                    if waitTimer ~= 0 % it's here to prevent restart 
                                      % of wait period if interrupted via
                                      % STOP while waiting
                        stop(waitTimer);
                    end;
                case OPS_INIT % INIT -- opStatus remains the same
                    set(LbStatus,'String',C_MSG_INIT);
            end
            if ModeSel ~= OPS_INIT
                opStatus = ModeSel;
            end;
            drawnow;
        end % func StartStop
        
        function SetDialogProps
            set(CboxLogToFile,'Value',VAR_LogToFile);
            set(CboxNetworkMode,'Value',VAR_MutexEnabled);
            
            set(CboxRunTimer,'Value',VAR_RunTimer);
            CboxRunTimer_callback(CboxRunTimer,0,0);
            set(EdRunTimerStart,'string',num2str(VAR_RunTimerStart(1)));
            set(EdRunTimerEnd,'string',num2str(VAR_RunTimerEnd(1)));
            set(CboxCooldownTimer,'Value',VAR_CooldownTimer_Enabled);
            set(CboxWeekend,'Value',VAR_WeekendRun);
            
            set(EdCommonPlugins,'string',VAR_DefaultPluginDir);
            if VAR_OptRatio_Override == -1
                set(OptSlider,'Enable','off');
                set(OptSlider,'Value',floor(opt_ratio_perf));
                set(LbOptPercent,'string',num2str(floor(opt_ratio_perf)));
                set(CboxOPTAuto,'Value',1);
            else
                set(OptSlider,'Enable','on');
                set(OptSlider,'Value',floor(VAR_OptRatio_Override));
                set(LbOptPercent,'string',num2str(floor(VAR_OptRatio_Override)));
                set(CboxOPTAuto,'Value',0);
            end;
        end

        function GetDialogProps
            VAR_LogToFile = get(CboxLogToFile,'Value');
            VAR_MutexEnabled = get(CboxNetworkMode,'Value');
            
            VAR_RunTimer = get(CboxRunTimer,'Value');
            VAR_RunTimerStart = [str2num(get(EdRunTimerStart,'string')) 0 0];
            VAR_RunTimerEnd = [str2num(get(EdRunTimerEnd,'string')) 0 0];
            VAR_CooldownTimer_Enabled = get(CboxCooldownTimer,'Value');
            VAR_WeekendRun = get(CboxWeekend,'Value');
            
            VAR_DefaultPluginDir = get(EdCommonPlugins,'string');
            if (get(CboxOPTAuto,'Value') > 0)
                VAR_OptRatio_Override = -1;
            else
                VAR_OptRatio_Override = get(OptSlider,'Value');
            end;
        end
        
        function ListDITable
			% lists DITable contents to the visual log
			% callers: SelectDir (BrowseDir_callback, dialog_create (if VAR_AutoSelect)),
			% BrowseFiles_callback, Operator_Callback, Autorun_Callback
            try
			
				ss = get(LogControl,'string');
        
				if numel(ss) > C_VLOG_CLC_LIMIT
					vLogCLC;
					vLog(sprintf(C_MSG_VLOGCLC,C_VLOG_CLC_LIMIT));
				end;
            
                DIthingstodo = 0;
                for DIi = 1:DITableSize
                    if DITable(DIi).Status ~= DIS_READY
                        continue;
                    end;

                    if isempty(DITable(DIi).InFile)
                        ME = MException('EEGbatch:NO_INFILE',C_MSG_LISTDITABLE_NOINFILE);
                        throw(ME);
                    else
                        [~, ~, Subj1 Cond1 Phase1] = UnpackFilename(DITable(DIi).InFile{1}); % v0.2.002 char( removed
                    end;
                    if isempty(DITable(DIi).OutFile)
                        Subj2 = ''; Cond2 = ''; Phase2 = C_MSG_LISTDITABLE_INTERNAL_OUTPHASE;
                    else
                        [~, ~, Subj2 Cond2 Phase2] = UnpackFilename(DITable(DIi).OutFile{1,1}); % v0.2.002 char( removed
                    end;

                    log_input = sprintf('%s %s (%s)',Subj1,Cond1,Phase1);
                    log_func = DITable(DIi).Func;
                    log_output = sprintf('%s %s (%s)',Subj2,Cond2,Phase2); 
                    if numel(DITable(DIi).InFile) > 1
                        log_input = strcat(log_input,',...');
                    end;
                    DITable(DIi).logpos = vLog(sprintf('%s   %s   %s',log_input,log_func,log_output));

                    %if (opStatus == OPS_RUN) || (DITable(DIi).AutoFN == 1)
					%if (DITable(DIi).AutoFN == 1) || (opStatus ~= OPS_AUTO) % v0.2.001
					if ((opStatus == OPS_AUTO) && (DITable(DIi).AutoFN == 1)) || ...
						((opStatus == OPS_USERONLY) && (DITable(DIi).AutoFN == 0)) || ...
						(opStatus == OPS_RUN) % v0.2.002
                        % If in AUTO mode, we're counting only AutoFN 
                        % functions into thingstodo
                        DIthingstodo = DIthingstodo + 1;
                    end; 
                end;
				
				xLogDITable;
                
            catch exception % **A191xB**
                
				aeLog(sprintf(C_MSG_INTERRORLDI,exception.message));
				if VAR_DetailedExceptions % v0.2.003
					stringtoreport = Exception2Report(exception);
					fprintf('%s',stringtoreport);
					if VAR_ErrorLog
						eLog(stringtoreport);
					elseif VAR_LogToFile
						fLog(stringtoreport);
					end;
				end;

				if VAR_ThrowExceptions 
					rethrow(exception);
				end;
                
            end; % try-catch
			
            
        end % func ListDITable
        
        function LetsGoMessage
            if isnumeric(DIthingstodo) && (DIthingstodo > 0)
                vLog(sprintf(C_MSG_LETS_GO,C_DI_START,C_DI_AUTOMODE));
            else
                vLog(C_MSG_NOPE);
            end;
        end
        
        function LetsGoMessage2
            vLog(C_MSG_BYFILES_ENDED);
        end
        
        function OptSlider_callback(hObject, eventdata, handles)
            set(LbOptPercent,'string',num2str(round(get(hObject,'Value'))));
        end
        
        function CboxRunTimer_callback(hObject, eventdata, handles)
            if get(hObject,'Value')
                s = 'on';
            else
                s = 'off';
            end;
            set(CboxWeekend,'Enable',s);
            set(EdRunTimerStart,'Enable',s);
            set(EdRunTimerEnd,'Enable',s);
            set(LbTimer1,'Enable',s);
            set(LbTimer2,'Enable',s);
        end
        
        function OptPercentAuto_Callback(hObject, eventdata, handles)
            checked = get(hObject,'Value');
            if checked
                set(OptSlider,'Enable','off');
            else
                set(OptSlider,'Enable','on');
            end;
        end
        
        function SelectDir(dirname)
            if (~isnumeric(dirname)) && ~isempty(dirname)
                StartStop(OPS_INIT);
                if exist(dirname,'dir')
                    set(EdPath,'string',dirname);
                    dirlist = dir(strcat(dirname,'\*.*'));
                    
                    SearchDatasets(SDS_BYDIR,get(EdPath,'String'));
                    % this initializes glob_findin
                    % try-catch has been moved to SearchDatasets
                    
                    set(LbSelected,'string',sprintf(C_MSG_FILESFOUND,numel(dirlist)));
                    selectByFile = 0;

                    % v0.1.016 
                    if DITableSize > 0            
                        ListDITable;
                        LetsGoMessage;
                    end;
                else
                    glob_findin = '';
                    errordlg(C_MSG_DIRNOTFOUND,C_MSG_DIRNOTFOUND_TITLE,'modal');
                end;
                StartStop(OPS_STOP);                    
            else
                glob_findin = '';
                set(LbSelected,'string',C_MSG_FILESNOTCHOSEN);
            end;
        end

        function BrowseDir_Callback(hObject, eventdata, handles)

            dirname = uigetdir(VAR_DefaultDir,C_DI_POPUPDIR);
            SelectDir(dirname);
        end
		
		function RefreshDir_Callback(hObject, eventdata, handles)
			if glob_findin_check
				SelectDir(glob_findin);
			end;
		end % func RefreshDir_Callback
        
        function [OK] = glob_findin_check
            OK = 1;
            if strcmpi(glob_findin,'')
                errordlg(C_MSG_NOWORKDIR,C_MSG_NOWORKDIR_TITLE,'modal');
                OK = 0;
            end;
            if OK && ~exist(glob_findin,'dir')
                errordlg(C_MSG_DIRNOTFOUND,C_MSG_DIRNOTFOUND_TITLE,'modal');
                OK = 0;
            end;
        end % func glob_findin_check
        
        % callback of "i choose myself" button
        function BrowseFiles_Callback(hObject, eventdata, handles)
            [dirlist, pathname, ~] = uigetfile('*.*',C_DI_POPUPFILE,'Multiselect','on');            
            if ~isnumeric(dirlist)
                StartStop(OPS_INIT);
                set(EdPath,'string','');
                
                if ~strcmpi(pathname,'')
                    if ~(pathname(end) == '\')
                        pathname = strcat(pathname,'\');
                    end;
                else
                    ME = MException('EEGbatch:NoPathButFiles',C_MSG_NOPATHBUTFILES);
                    throw(ME);
                end;
                
                if ~iscell(dirlist)
                    dirlist = {dirlist};
                end;
    
                if numel(dirlist) > 0
                    dirlist{1} = strcat(pathname,dirlist{1});
                end;
                
                SearchDatasets(SDS_BYFILES,dirlist);
                
                set(LbSelected,'string',sprintf(C_MSG_FILESCHOSEN,numel(dirlist)));
                selectByFile = 1;
                
                if DITableSize > 0            
                    ListDITable;
                    LetsGoMessage;
                end;
                
                StartStop(OPS_STOP);
            else
                set(LbSelected,'string',C_MSG_FILESNOTCHOSEN);
                glob_findin = '';
            end;
                        
        end
        
        % callback of "Go" button
        function Operator_Callback(hObject, eventdata, handles)

            if (opStatus == OPS_RUN) || (opStatus == OPS_AUTO) || (opStatus == OPS_USERONLY) || (opStatus == OPS_TERMINATING)
                StartStop(OPS_TERMINATING); % if flag says it was running --> set to terminating
            else % (if opStatus == OPS_STOP)
                if selectByFile == 0
					if hObject == StartStopBtn
						StartStop(OPS_RUN); % button: StartStopBtn, flag<-RUN
					else
						StartStop(OPS_USERONLY); % button: UserOnlyBtn, flag<-USERONLY
					end;
                    GetDialogProps;
                    if glob_findin_check
						if hObject == StartStopBtn
							ProcessDITable(PDI_USERMODE,glob_findin);
						else
							ProcessDITable(PDI_USERONLY,glob_findin);
						end;
                        SearchDatasets(SDS_BYDIR,glob_findin);
                        ListDITable;
                        LetsGoMessage;
                        MAKESomeNoise;
                    end;
                    StartStop(OPS_STOP);
                else
                    if hObject == StartStopBtn
						StartStop(OPS_RUN); % button: StartStopBtn, flag<-RUN
					else
						StartStop(OPS_USERONLY); % button: UserOnlyBtn, flag<-USERONLY
					end;
                    GetDialogProps;
                    if glob_findin_check
                        if hObject == StartStopBtn
							ProcessDITable(PDI_USERMODE,glob_findin);
						else
							ProcessDITable(PDI_USERONLY,glob_findin);
						end;
                        LetsGoMessage2;
                        MAKESomeNoise;
                    end;
                    StartStop(OPS_STOP);
                end;
                
            end; % if opStatus == OPS_STOP

        end % func Operator_callback

        % Autorun callback
        function AutoRun_Callback(hObject, eventdata, handles)
        
            if (opStatus == OPS_RUN) || (opStatus == OPS_AUTO) || (opStatus == OPS_USERONLY) || (opStatus == OPS_TERMINATING)
                % if flag says running --> TERMINATING, if TERMINATING
                % already --> do nothing
                StartStop(OPS_TERMINATING); 
            else
                % if flag says stopped --> start
                if selectByFile == 0
                    StartStop(OPS_AUTO);
                    GetDialogProps;
                    if glob_findin_check
                        while (opStatus == OPS_AUTO) % run until TERMINATING signal
                            DIthingstodo = 1; % first iteration to run unconditionally
                            while (DIthingstodo > 0) && (opStatus == OPS_AUTO)
                                % while there's anything to do 
                                % (DIthingstodo > 0) and no TERMINATING
                                % signal
                                drawnow; SearchDatasets(SDS_BYDIR,glob_findin);
                                drawnow; ListDITable;
                                drawnow; ProcessDITable(PDI_AUTOMODE,glob_findin);
                            end;
                            
                            if (opStatus ~= OPS_TERMINATING)
                                % (opStatus ~= -1) thus this wasn't the reason 
                                % of jumping out the loop --> the other reason
                                % could be running out of tasks. We're going 
                                % to wait for a VAR_SearchAgainWait long pause 
                                % then look for tasks again.
                                aLog(sprintf(C_MSG_SEARCH_HLT,VAR_SearchAgainWait));
                                waitTimer = timer('TasksToExecute',1,'TimerFcn',@waittimer_nope_callback,'StartDelay',VAR_SearchAgainWait*[3600 60 1]');
                                start(waitTimer);
                                wait(waitTimer); waitTimer = 0;
                                cooldown_rs = clock; % we've just stopped waiting for tasks, no need to cool down now
                            end;
                            
                        end; % while
                    end; % if glob_findin_check
                    StartStop(OPS_STOP);
                    cooldown_rs = zeros(1,6);
                    
                else
                    errordlg(C_MSG_CANNOT_AUTOMATE_BYFILES,C_MSG_CANNOT_AUTOMATE_BYFILES_TITLE,'modal');
                end; % if selectbyfile
            end;
        end
        function Cleanup_Callback(hObject, eventdata, handles)
			GetDialogProps;
			if glob_findin_check 
				vLog(C_MSG_STARTCLEANUP);
				vLog(C_MSG_STARTCONDENSING);
				fLogCondense(glob_findin,1)
				vLogAdd(C_MSG_STARTCONDENSINGDONE);
				vLog(C_MSG_STARTMUTEXRELEASE);
				[cleared, owners] = ResetMutex(glob_findin,1);
				if cleared == 0
					vLogAdd(C_MSG_STARTMUTEXRELEASEDONE);
				end;
				vLog(C_MSG_ENDCLEANUP);
			end; % glob_findin_check
		end 
        function ShowComputers_Callback(hObject, eventdata, handles)
			GetDialogProps;
			if glob_findin_check
				mainPERFtable = egb_showcomp(mainPERFtable);
			end; % glob_findin_check
		end
		
        function OPTableEditor_Callback(hObject, eventdata, handles)
            if glob_findin_check
                dialog_OPTableEditor;
            end;
        end
        function PluginEditor_Callback(hObject, eventdata, handles)
            if glob_findin_check
                dialog_PluginEditor;
            end;
			% disabled, vLogCLC test:
			%for i = 1:C_vLogCLCLimit-100
			%	vLog(sprintf('DUMMY %u',i));
			%end;
        end
		function SaveSettings_Callback(hObject, eventdata, handles)
			SaveSettings(settingsfile);
		end
		function Restart_Callback(hObject, eventdata, handles)
			if VAR_DISPmain, disp(C_DISP_MAINWNDCLOSING); end;
			delete(MainDialog);
			if VAR_DISPmain, disp(C_DISP_EEGBATCHRESTART); end;
			EEGbatch_restart;
		end
    
    end % func dialog_create

    function waittimer_nope_callback(obj, event)
    end
	
    function dialog_OPTableEditor()
        
        % eOP
        eOPTable(C_OPTABLES_NR_DEFAULT) = OPTables(1,1);
		% this stores the currently displayed OPTable, plus handles for the controls connected to it (eid)
		% structure changed v0.1.009: to exactly the same as OPTables' structure
                                            
        eOPind = 0;
		% eOPTable's index in OPTables
        
        % UNDO
        UNDOlines(C_UNDO_SIZE_TABLE_EDITOR) = eOPTable(1);
        UNDOdata(C_UNDO_SIZE_TABLE_EDITOR) = struct('COM',0,'POS1',0,'POS2',0);
        UNDOptr = 0;
        
        OPTableEditor = dialog('WindowStyle','normal','Name',C_DI_OPTABLEEDITOR_CAPTION);
        siz = get(OPTableEditor,'Position');
        siz(3) = 760; % change the width
        set(OPTableEditor,'Position',siz);
        OEditor = uipanel(OPTableEditor,'Position',[0 0 .75 .95],'Title',C_DI_OEDITOR);
        OEditor_savedcolor = get(OEditor,'backgroundcolor');

        LbPrj = uicontrol(OEditor,'style','text','Position',                    [5 390 200 20], ...
            'string','','HorizontalAlignment','left');
        LbSubjGr = uicontrol(OEditor,'style','text','Position',                 [225 390 200 20], ...
            'string','','HorizontalAlignment','left');
        BtnNew = uicontrol(OPTableEditor,'style','pushbutton','Position',           [580 305 176 40], ...
            'string',C_DI_EOP_NEW,'Enable','on','callback',@New_callback);
        BtnSave = uicontrol(OPTableEditor,'style','pushbutton','Position',          [580 255 70 40], ...
            'string',C_DI_EOP_SAVE,'Enable','off','callback',@Save_callback);
        BtnSaveAs = uicontrol(OPTableEditor,'style','pushbutton','Position',        [686 255 70 40], ...
            'string',C_DI_EOP_SAVEAS,'Enable','on','callback',@SaveAs_callback);
        BtnUndo = uicontrol(OPTableEditor,'style','pushbutton','Position',          [580 205 70 40], ...
            'string',C_DI_EOP_UNDO,'Enable','off','callback',@Undo_callback);
        BtnRevert = uicontrol(OPTableEditor,'style','pushbutton','Position',        [686 205 70 40], ...
            'string',C_DI_EOP_REVERT,'Enable','off','callback',@Revert_callback);
        BtnFirst = uicontrol(OPTableEditor,'style','pushbutton','Position',         [580 155 44 40], ...
            'string',C_DI_EOP_FIRST,'Enable','on','callback',@First_callback); 
        BtnLeft = uicontrol(OPTableEditor,'style','pushbutton','Position',          [624 155 44 40], ...
            'string',C_DI_EOP_LEFT,'Enable','off','callback',@Left_callback);
        BtnRight = uicontrol(OPTableEditor,'style','pushbutton','Position',         [668 155 44 40], ...
            'string',C_DI_EOP_RIGHT,'callback',@Right_callback);
        BtnLast = uicontrol(OPTableEditor,'style','pushbutton','Position',          [712 155 44 40], ...
            'string',C_DI_EOP_LAST,'Enable','on','callback',@Last_callback); 
        LbnOFm = uicontrol(OPTableEditor,'style','text','Position',                 [580 350 176 30], ...
            'string',sprintf(C_DI_EOP_N_OF_M,1,OPTableSize));    
        LbeOPStatus = uicontrol(OPTableEditor,'style','text','Position',            [580 390 176 20], ...
            'string',C_DI_EOP_IDLE,'ForegroundColor','red');    
        
        if OPTableSize > 0
            LoadeOPTable(1);
        else
            LoadeOPTable(0);
        end;
        
        function eOPWorking
            set(LbeOPStatus,'string',C_DI_EOP_LOADING);
            drawnow;
        end
        
        function eOPSaving
            set(LbeOPStatus,'string',C_DI_EOP_SAVING);
            drawnow;
        end            
        
        function eOPIdle
            set(LbeOPStatus,'string',C_DI_EOP_IDLE);
            drawnow;
        end
        
        function LoadeOPTable(iii)
            eOPWorking;
            if iii > 0
                if (eOPind > 0) && ~isempty(eOPTable(1).eid)
                    clear_eOP;
                end;
                eOPind = iii;
                eOPTable = OPTables(eOPind,:);
                fetch_eOP;
            else
                eOPind = iii;
            end;
            updatelabels(eOPind);
            eOPIdle;
        end
        
        function updatelabels(ind)
            set(LbnOFm,'string',sprintf(C_DI_EOP_N_OF_M,ind,OPTableSize));
            if ind == 0
                set(LbPrj,'string','');
                set(LbSubjGr,'string','');
                set(BtnFirst,'Enable','off');
                set(BtnLeft,'Enable','off');
                set(BtnRight,'Enable','off');
                set(BtnLast,'Enable','off');
                set(BtnSaveAs,'Enable','off');
                set(OEditor,'backgroundcolor',[.7 .7 .7]);
            else
                set(LbPrj,'string',sprintf(C_MSG_PRJLABEL,OPTableNames(ind).Prj));
                set(LbSubjGr,'string',sprintf(C_MSG_SUBJGRLABEL,OPTableNames(ind).SubjGr));
                set(BtnFirst,'Enable','on');
                set(BtnLast,'Enable','on');
                set(BtnSaveAs,'Enable','on');
                if ind == 1
                    set(BtnLeft,'Enable','off');
                else
                    set(BtnLeft,'Enable','on');
                end;
                if ind == OPTableSize
                    set(BtnRight,'Enable','off');
                else
                    set(BtnRight,'Enable','on');
                end;
                set(OEditor,'backgroundcolor',OEditor_savedcolor);
            end; % if ind != 0
            set(BtnUndo,'Enable','off');
            set(BtnSave,'Enable','off');
            set(BtnRevert,'Enable','off');
        end
        
        function eOPChanged
            set(BtnRevert,'Enable','on');
            set(BtnUndo,'Enable','on');
            set(BtnSave,'Enable','on');
        end
        
        function eOPUnChanged
            set(BtnRevert,'Enable','off');
            set(BtnUndo,'Enable','off');
            set(BtnSave,'Enable','off');
            UNDOptr = 0; %v0.1.011
        end

        function clear_eOP
            for i = 1:numel(eOPTable)
                if ~strcmpi(eOPTable(i).Func,'') && ~isempty(eOPTable(i).Func)
                    for j = 1:numel(eOPTable(i).eid)
                        delete(eOPTable(i).eid(j));
                    end;
                    eOPTable(i).eid = [];
                else
                    break;
                end;
            end;
        end % func clear_eOP

        function fetch_eOP
            C_CONTROL_NEXT = 25;    C_CONTROL_START = 360;
            vert_pos = C_CONTROL_START;
            for i = 1:numel(eOPTable)
                if ~strcmpi(eOPTable(i).Func,'') && ~isempty(eOPTable(i).Func)

                    ements = {};

                    [ements] = PackOPTableLine(eOPTable(i));


                    p3v = 0;
                    for k1 = 1:numel(C_BuiltInFunc)
                        if strcmpi(ements{3},C_BuiltInFunc{k1})
                            p3v = k1;
                            break;
                        end;
                    end;
                    if p3v == 0
                        p3v = 1;
                    end;

                    eOPTable(i).eid(1) = uicontrol(OEditor,'Style','edit','string',ements{1},'Position',          [45 vert_pos 80 20], ...
                        'callback',@allcallback);
                    eOPTable(i).eid(2) = uicontrol(OEditor,'Style','edit','string',ements{2},'Position',          [130 vert_pos 80 20], ...
                        'callback',@allcallback);
                    eOPTable(i).eid(3) = uicontrol(OEditor,'style','popupmenu','Position',                        [215 vert_pos 100 20], ...
                        'string',C_BuiltInFunc,'value',p3v,'callback',@allcallback);
                    eOPTable(i).eid(4) = uicontrol(OEditor,'Style','edit','string',ements{4},'Position',          [320 vert_pos 80 20], ...
                        'callback',@allcallback);
                    eOPTable(i).eid(5) = uicontrol(OEditor,'Style','edit','string',ements{5},'Position',          [405 vert_pos 80 20], ...
                        'callback',@allcallback);
                    eOPTable(i).eid(6) = uicontrol(OEditor,'Style','pushbutton','Position',                       [5 vert_pos 20 20], ...
                        'String','+','callback',@allcallback);
                    eOPTable(i).eid(7) = uicontrol(OEditor,'Style','pushbutton','Position',                       [25 vert_pos 20 20], ...
                        'String','X','callback',@allcallback);
                    eOPTable(i).eid(8) = uicontrol(OEditor,'Style','pushbutton','Position',                       [485 vert_pos 20 20], ...
                        'String','^','callback',@allcallback);
                    eOPTable(i).eid(9) = uicontrol(OEditor,'Style','pushbutton','Position',                       [505 vert_pos 20 20], ...
                        'String','¡','callback',@allcallback);

                    if i == 1
                        set(eOPTable(i).eid(8),'Enable','off');
                    end;

                    vert_pos = vert_pos - C_CONTROL_NEXT;

                else
                    set(eOPTable(i-1).eid(9),'Enable','off');
                    break;
                end; % if strcmpi ...
            end % for i

        end % func fetch_eOP

        function insert_eOP(pos)
            for i = 1:numel(eOPTable)
                if strcmpi(eOPTable(i).Func,'') || isempty(eOPTable(i).Func)
                    break;
                end;
            end;
            for j = i:-1:pos+1
                eOPTable(j) = eOPTable(j-1);
            end;
            eOPTable(pos).InMask = '';
            eOPTable(pos).Conds = {{}};
            eOPTable(pos).Func = 'DO_PREP19';
            eOPTable(pos).Params = '';
            eOPTable(pos).OutMask = {{}};
            eOPTable(pos).eid = [];
            eOPChanged;
        end % func insert_eOP

        function swap_eOP(i,j)
            tmp = eOPTable(j);
            eOPTable(j) = eOPTable(i);
            eOPTable(i) = tmp;
            eOPChanged;
        end % func swap_eOP

        function delete_eOP(pos)
		% deletes line number "pos" from eOPTable
        
            for i = 1:numel(eOPTable)
                if strcmpi(eOPTable(i).Func,'') || isempty(eOPTable(i).Func)
                    break;
                end;
            end;
            
            for j = pos+1:i
                eOPTable(j-1) = eOPTable(j);
            end;
            
            eOPTable(i).Func = '';
            eOPChanged;
        end % func delete_eOP  
        
        function update_eOP(pos,cpos)
            ements = {};
            [ements] = PackOPTableLine(eOPTable(pos));
            switch cpos
                case {1,2,4,5}
                    ements{cpos} = get(eOPTable(pos).eid(cpos),'string');
                case 3
                    %TODO: implement
            end
            [eOPTable(pos)] = UnpackOPTableLine(eOPTable(pos),ements);
            
            eOPChanged;
        end
        
        function [nOPt nPrj nSubjGr] = dialog_OPTableNew()
            % make a new op-table, based on builtin functions
            % and user-defined properties, parameters
            % mainly the callback of 'New' button on OP-table-editor window
            opt_start_y = 275; opt_delta_y = 25;
            osy = opt_start_y; ody = opt_delta_y; nOPt_valid = 0;
            proptext = {'style', 'text','string'};
            propchk = {'style','checkbox','callback',@onoff_callback,'string'};
            propedit = {'style','edit','callback',@changed_callback};
            OC_CC = [.7 .7 .7];
            
            nOPt(C_OPTABLES_NR_DEFAULT) = OPTables(1,1);

            OPTableCreator = dialog('WindowStyle','normal','Name',C_DI_OC_OCREATOR,'Position',[100 100 935 300]);
            siz = get(OPTableCreator,'Position');
            siz(3) = 935; % change width and height
            siz(4) = 300;
            set(OPTableCreator,'Position',siz);
            

            a = uicontrol(OPTableCreator,proptext{:},C_DI_OC_SETTINGS,'Position',           [5 osy 460 ody-5]);
            b = uicontrol(OPTableCreator,proptext{:},C_DI_OC_RESULT,'Position',             [470 osy 460 ody-5]);
            set(a,'backgroundcolor',OC_CC); set(b,'backgroundcolor',OC_CC);

                osy = osy - ody;
                
            nPrj = ''; nSubjGr = '';
            uicontrol(OPTableCreator,proptext{:},C_DI_OC_PRJ,'Position',                [5 osy 90 ody-5]);
            EdPrj = uicontrol(OPTableCreator,propedit{:},'Position',                   [100 osy 75 ody-5]);
            uicontrol(OPTableCreator,proptext{:},C_DI_OC_SUBJGR,'Position',                [180 osy 90 ody-5]);
            EdSubjGr = uicontrol(OPTableCreator,propedit{:},'Position',                   [275 osy 75 ody-5]);

                osy = osy - ody;
                
            EdCFiles = uicontrol(OPTableCreator,proptext{:},C_DI_OC_FILES,'Position',	[5 osy 180 ody-5]);
            EdFiles = uicontrol(OPTableCreator,propedit{:},'Position',                  [200 osy 150 ody-5]);

                osy = osy - ody;

            uicontrol(OPTableCreator,proptext{:},C_DI_OC_POP_IMPORT,'Position',          [5 osy 100 ody-5]);
            PopImport = uicontrol(OPTableCreator,'style','popupmenu','Position',		[110 osy 80 ody-5], ...
                'string',{C_DI_OC_STD19, C_DI_OC_STD64, C_DI_OC_OWN, C_DI_OC_NONE},'value',1, ...
                'callback',@popimport_callback); 
            EdOwnImport = uicontrol(OPTableCreator,propedit{:},'Position', [200 osy 150 ody-5],'Visible','off');

                osy = osy - ody;

            uicontrol(OPTableCreator,proptext{:},C_DI_OC_SAMPLING_RATE,'Position',              [5 osy 100 ody-5]);
            EdSamplingRate = uicontrol(OPTableCreator,propedit{:},'Position',           [110 osy 50 ody-5], ...
                'string','200');
            EdCChanLocs = uicontrol(OPTableCreator,proptext{:},C_DI_OC_CHAN_LOCS,'Position',           [170 osy 100 ody-5]);
            EdChanLocs = uicontrol(OPTableCreator,propedit{:},'Position',               [280 osy 150 ody-5]);

                osy = osy - ody;

            CboxAddEventCh = uicontrol(OPTableCreator,propchk{:},C_DI_OC_ADD_EVENT_CHANNEL, ...
                'value',1,'Position',                                                       [5 osy 130 ody-5]);
            a = uicontrol(OPTableCreator,proptext{:},C_DI_OC_EVENT_STEP,'Position',          [140 osy 50 ody-5]);
            EdEventChStep = uicontrol(OPTableCreator,propedit{:},'Position',            [200 osy 50 ody-5], ...
                'string',512);
            CboxAddEventChNrAuto = uicontrol(OPTableCreator,propchk{:},C_DI_OC_ADD_EVENT_CHANNEL_AUTO, ...
                'value',1,'Position',                                                   [260 osy 130 ody-5]);
            EdAddEventChNr = uicontrol(OPTableCreator,propedit{:},'Position',[400 osy 50 ody-5]);
            set(CboxAddEventCh,'UserData',[a,EdEventChStep,CboxAddEventChNrAuto,EdAddEventChNr]);

                osy = osy - ody;

            CboxEvents = uicontrol(OPTableCreator,propchk{:},C_DI_OC_EVENTS,'Position', [5 osy 180 ody-5], ...
                'value',1);
            EdEventChNrAuto = uicontrol(OPTableCreator,propchk{:}, ...
                C_DI_OC_EVENT_CHANNEL_AUTO,'value',1,'Position',                          [250 osy 130 ody-5]);
            EdEventChNr = uicontrol(OPTableCreator,propedit{:},'Position',              [390 osy 50 ody-5]);
            set(CboxEvents,'UserData',[EdEventChNrAuto,EdEventChNr]);

                osy = osy - ody;

            CboxHighpass = uicontrol(OPTableCreator,propchk{:},C_DI_OC_HIGHPASS,'Position', [5 osy 100 ody-5], ...
                'value',1);
            EdHighpass = uicontrol(OPTableCreator,propedit{:},'Position',               [110 osy 50 ody-5], ...
                'string','0.5');
            set(CboxHighpass,'UserData',[EdHighpass]);
            CboxLowpass = uicontrol(OPTableCreator,propchk{:},C_DI_OC_LOWPASS,'Position', [200 osy 100 ody-5], ...
                'value',1);
            EdLowpass = uicontrol(OPTableCreator,propedit{:},'Position',                [310 osy 50 ody-5], ...
                'string','45');
            set(CboxLowpass,'UserData',[EdLowpass]);

                osy = osy - ody;

            CboxEpoch = uicontrol(OPTableCreator,propchk{:},C_DI_OC_EPOCH,'Position',   [5 osy 150 ody-5], ...
                'value',1);
            CboxEpochAuto = uicontrol(OPTableCreator,propchk{:},C_DI_OC_EPOCH_AUTO,'Position',   [160 osy 120 ody-5], ...
                'value',1);
            a = uicontrol(OPTableCreator,proptext{:},C_DI_OC_EPOCH_LIMITS,'Position',    [290 osy 50 ody-5]);
            EdEpochLimit1 = uicontrol(OPTableCreator,propedit{:},'Position',            [350 osy 50 ody-5]);
            EdEpochLimit2 = uicontrol(OPTableCreator,propedit{:},'Position',            [410 osy 50 ody-5]);
            set(CboxEpoch,'UserData',[CboxEpochAuto,a,EdEpochLimit1,EdEpochLimit2]);

                osy = osy - ody;

            CboxBaseline = uicontrol(OPTableCreator,propchk{:},C_DI_OC_BASELINE,'Position',   [5 osy 150 ody-5], ...
                'value',1);
            CboxBaselineAll = uicontrol(OPTableCreator,propchk{:},C_DI_OC_BASELINE_ALL,'Position',   [160 osy 120 ody-5], ...
                'value',1);
            a = uicontrol(OPTableCreator,proptext{:},C_DI_OC_BASELINE_LIMITS,'Position',    [290 osy 50 ody-5]);
            EdBaseline1 = uicontrol(OPTableCreator,propedit{:},'Position',            [350 osy 50 ody-5]);
            EdBaseline2 = uicontrol(OPTableCreator,propedit{:},'Position',            [410 osy 50 ody-5]);
            set(CboxBaseline,'UserData',[CboxBaselineAll,a,EdBaseline1,EdBaseline2]);

                osy = osy - ody;

            CboxThresh = uicontrol(OPTableCreator,propchk{:},C_DI_OC_THRESH,'Position',  [5 osy 150 ody-5], ...
                'value',1);
            a = uicontrol(OPTableCreator,proptext{:},C_DI_OC_THRESH_LIMITS,'Position',    [160 osy 50 ody-5]);
            EdThresh1 = uicontrol(OPTableCreator,propedit{:},'Position',            [220 osy 50 ody-5], ...
                'string','-50');
            EdThresh2 = uicontrol(OPTableCreator,propedit{:},'Position',            [280 osy 50 ody-5], ...
                'string','50');
            set(CboxThresh,'UserData',[a,EdThresh1,EdThresh2]);

                osy = osy - ody;

            CboxDropEpoch = uicontrol(OPTableCreator,propchk{:},C_DI_OC_DROPEPOCH,'Position',[5 osy 150 ody-5], ...
                'value',1);
            CboxICA = uicontrol(OPTableCreator,propchk{:},C_DI_OC_ICA,'Position',[160 osy 150 ody-5], ...
                'value',1);        
            CboxDropComp = uicontrol(OPTableCreator,propchk{:},C_DI_OC_DROPCOMP,'Position',[315 osy 150 ody-5], ...
                'value',1);

            BtnSAVE = uicontrol(OPTableCreator,'style','pushbutton','string',C_DI_OC_SAVE, ...
                'callback',@callback_OCsave,'backgroundcolor',OC_CC,'Position',     [360 225 100 45]);

            EdResult = uicontrol(OPTableCreator,proptext{:},'','Enable','off','Position',      [470 osy 460 270]);
            set(EdResult,'HorizontalAlignment','left');
            
            ResultRefresh;
            
            waitfor(OPTableCreator);
            
            if not(nOPt_valid)
                nOPt = [];
            end;

            function ResultRefresh
                % rebuilds the result table at the right & 
                % the OP-table skeleton for OP-table-editor
                % based on the options on the left side
                ttab = '   ';
                oplinevis1 = ['%s' ttab ttab '%s' ttab '%s' ttab '%03u'];
                oplinevis = ['%03u' ttab ttab '%s' ttab '%s' ttab '%03u'];
                small_oplinevis = '%03u';
                pd = 10;        % phase code delta
                ph = -pd;       % phase code now
                ph_op = 1;      % op-table line nr
                s = {}; calc1 = -Inf; calc2 = -Inf;
                bs = get(EdResult,'string');
                
                nPrj = get(EdPrj,'string');
                nSubjGr = get(EdSubjGr,'string');
                
                s{end+1} = C_OPTABLE_BEGIN;

                switch get(PopImport, 'value')
                    case 1 % C_DI_OC_Std19
                        bothADD(get(EdFiles,'string'),'DO_PREP19', ...
                            strcat(get(EdSamplingRate,'string'),', ''',get(EdChanLocs,'string'),''''), ph+pd, 'first');
                    case 2 % C_DI_OC_Std64
                        bothADD(get(EdFiles,'string'),'DO_PREPEDF', ...
                            strcat('''',get(EdChanLocs,'string'),''''), ph+pd, 'first');
                    case 3 % C_DI_OC_Own
                        bothADD(get(EdFiles,'string'),get(EdOwnImport,'string'), ...
                            '', ph+pd, 'first');
                    case 4 % C_DI_OC_None
                        ph = str2num(get(EdFiles,'string'));
                end;

                if get(CboxAddEventCh,'value') == 1
                    if get(CboxAddEventChNrAuto,'value') == 1
                        bothADD(ph,'DO_ADDEVENTCH',get(EdEventChStep,'string'),ph+pd);
                    else
                        bothADD(ph,'DO_ADDEVENTCH',strcat(get(EdEventChStep,'string'),',',get(EdAddEventChNr,'string')),ph+pd);
                    end
                end;

                if get(CboxEvents,'value') == 1
                    if get(CboxAddEventChNrAuto,'value') == 1
                        bothADD(ph,'DO_EVENTS','',ph+pd);
                    else
                        bothADD(ph,'DO_EVENTS',get(EdEventChNr,'string'),ph+pd);
                    end;
                end;

                if get(CboxHighpass,'value') == 1
                    bothADD(ph,'DO_HIGHPASS',get(EdHighpass,'string'),ph+pd);
                end;

                if get(CboxLowpass,'value') == 1
                    bothADD(ph,'DO_LOWPASS',get(EdLowpass,'string'),ph+pd);
                end;

                if get(CboxEpoch,'value') == 1
                    if get(CboxEpochAuto,'value') == 1
                        calc1 = 0;
                        calc2 = (str2double(get(EdEventChStep,'string'))-1)/(str2double(get(EdSamplingRate,'string')));
                    else
                        calc1 = str2double(get(EdEpochLimit1,'string'));
                        calc2 = str2double(get(EdEpochLimit2,'string'));
                    end;
                    bothADD(ph,'DO_EPOCHS',strcat(num2str(calc1),',',num2str(calc2)),ph+pd);
                end;

                if get(CboxBaseline,'value') == 1
                    if get(CboxBaselineAll,'value') == 1
                        bothADD(ph,'DO_BASELINE','',ph+pd);
                    else
                        bothADD(ph,'DO_BASELINE',strcat(get(EdBaseline1,'string'),',',get(EdBaseline2,'string')),ph+pd);
                    end;
                end;

                if get(CboxThresh,'value') == 1
                    bothADD(ph,'DO_THRESH',strcat('-1,-1,',num2str(calc1),',',num2str(calc2),',',get(EdThresh1,'string'),',',get(EdThresh2,'string')),ph+pd);
                    
                end;

                if get(CboxDropEpoch,'value') == 1
                    bothADD(ph,'USER_DROPEPOCH','',ph+pd);
                end;

                if get(CboxICA,'value') == 1
                    bothADD(ph,'DO_MULTI_ICA','''runica'',''''''extended'''', 1'',''''',ph+pd);
                end;

                if get(CboxDropComp,'value') == 1
                    bothADD(ph,'USER_DROPCOMP','',ph+pd);
                end;

                s{end+1} = C_OPTABLE_END;
                nOPt(ph_op+1).Func = '';

                rfrs = 0;
                if (numel(bs) == 0) || (numel(bs) ~= numel(s))
                    rfrs = 1;
                else
                    for i = 1:numel(bs)
                        if ~strcmp(bs{i},s{i})
                            rfrs = 1;
                        end;
                    end;
                end;
                if rfrs
                    set(EdResult,'string',s);
                end;
                
                function bothADD(p1,p2,p3,p4,first)
                    % simply calls opADD and sADD
                    % they add one line to the
                    % output-pane at the right (sADD) and
                    % the OP-table-skeleton gonna be used in
                    % OP-table-editor (opADD)
                    % first tells sADD that it should use oplinevis1
                    % instead of oplinevis, and also tells opADD that
                    % it should not convert InMask, because it's a string
                    if nargin > 4
                        opADD(p1,p2,p3,p4,1);
                        sADD(p1,p2,p3,p4,1);
                    else
                        opADD(p1,p2,p3,p4,0);
                        sADD(p1,p2,p3,p4,0);
                    end;
                end % ResultRefresh.bothADD
                function opADD(p1,p2,p3,p4,first)
                    % see bothADD
                    nOPt(ph_op).InMask = {};
                    nOPt(ph_op).OutMask = {};
                    nOPt(ph_op).Conds = {};
                    
                    if ~first
                        % p1,p4 -> string
                        p1 = sprintf(small_oplinevis,p1);
                        p4 = sprintf(small_oplinevis,p4);
                    else
                        % p4 -> string
                        p4 = sprintf(small_oplinevis,p4);
                    end;
                    nOPt(ph_op).InMask = p1; % was: InMask{1} % v0.2.001
                    nOPt(ph_op).Func = p2;
                    nOPt(ph_op).Params = p3;
                    nOPt(ph_op).OutMask{1} = p4;
                    
                    ph_op = ph_op + 1;
                end % ResultRefresh.opADD
                function sADD(p1,p2,p3,p4,first)
                    % see bothADD
                    if first
                        s{end+1} = sprintf(oplinevis1,p1,p2,p3,p4);
                    else
                        s{end+1} = sprintf(oplinevis,p1,p2,p3,p4);
                    end;
                    ph = ph + pd;
                end % ResultRefresh.sADD
            end % ResultRefresh
            
            function onoff_callback(hObject, eventdata, handles)
                % callback func of controls which show/hide other
                % controls, onoff_list is retrieved from the controls'
                % userdata
                onoff_list = get(hObject,'UserData'); ONoff = get(hObject,'value');
                if ~isempty(onoff_list) && ~isnumeric(onoff_list)
                    if ONoff
                        for i = 1:numel(onoff_list)
                            set(onoff_list,'Visible','on');
                        end;
                    else
                        for i = 1:numel(onoff_list)
                            set(onoff_list,'Visible','off');
                        end;
                    end;
                end;
                changed_callback;
            end
            
            function changed_callback(hObject, eventdata, handles)
                % callback of edit controls
                ResultRefresh;
            end
            
            function popimport_callback(hObject, eventdata, handles)
                % callback of import_type control, shows/hides
                % other controls based on the value of import_type
                % XOK implement 20120227
                switch get(hObject,'Value')
                    case 1 % PREP19
                        set(EdFiles,'Visible','on');
                        set(EdOwnImport,'Visible','off');
                        set(EdCChanLocs,'Visible','on');
                        set(EdChanLocs,'Visible','on');
                        set(EdCFiles,'string',C_DI_OC_FILES);
                    case 2 % PREP64
                        set(EdFiles,'Visible','on');
                        set(EdOwnImport,'Visible','off');
                        set(EdCChanLocs,'Visible','off');
                        set(EdChanLocs,'Visible','off');
                        set(EdCFiles,'string',C_DI_OC_FILES);
                    case 3 % own
                        set(EdFiles,'Visible','on');
                        set(EdOwnImport,'Visible','on');
                        set(EdCChanLocs,'Visible','on');
                        set(EdChanLocs,'Visible','on');
                        set(EdCFiles,'string',C_DI_OC_FILES);
                    case 4 % dataset
                        set(EdFiles,'Visible','on');
                        set(EdOwnImport,'Visible','off');
                        set(EdCChanLocs,'Visible','off');
                        set(EdChanLocs,'Visible','off');
                        set(EdCFiles,'string',C_DI_OC_PHASE);
                end;
                ResultRefresh;
            end
            
            function callback_OCsave(hObject, eventdata, handles)
                % OP-table maker 'Save' button callback
                % it gives the prepared OP-table-skeleton
                % to OP-table-editor (by setting nOPt_valid to 1
                % meaning that nOPt shouldn't be deleted before
                % giving back control to op-table-editor
                if strcmpi(get(EdPrj,'string'),'')
                    % cannot save w/o a proper project name
                    errordlg(C_MSG_OC_CANNOTSAVEEMPTYPRJ,C_MSG_OC_ERRORSAVING_TITLE,'modal');
                    return;
                end;
                nOPt_valid = 1;
                ResultRefresh;
                delete(get(hObject,'parent'));
            end

        end % func dialog_OPTableNew
        
        function Undo_callback(hObject, eventdata, handles)
            eOPWorking;
            
            clear_eOP;
            
            if UNDOptr > 0
                switch UNDOdata(UNDOptr).COM
                    case 6 % INS
                        delete_eOP(UNDOdata(UNDOptr).POS1);
                    case 7 % DEL
                        insert_eOP(UNDOdata(UNDOptr).POS1);
                        eOPTable(UNDOdata(UNDOptr).POS1) = UNDOlines(UNDOptr);
                    case {8,9} % SWAP
                        swap_eOP(UNDOdata(UNDOptr).POS1,UNDOdata(UNDOptr).POS2);
                    case 111 % CHANGE
                        eOPTable(UNDOdata(UNDOptr).POS1) = UNDOlines(UNDOptr);
                end;
                
                UNDOptr = UNDOptr - 1;
                if UNDOptr < 1
                    eOPUnChanged;
                end;
            end;
            
            fetch_eOP;
            eOPIdle;
        end
        
        function Save_callback(hObject, eventdata, handles)
            res = 0; attempt = 0; s = 0;
            if strcmpi(OPTableNames(eOPind).SubjGr,'')
                defname = strcat(glob_findin,sprintf(C_OPTABLE_FILENAME_FORMAT_WO_SUBJGR,OPTableNames(eOPind).Prj));
            else
                defname = strcat(glob_findin,sprintf(C_OPTABLE_FILENAME_FORMAT,OPTableNames(eOPind).Prj,OPTableNames(eOPind).SubjGr));
            end;
            while (attempt < 1000) && ~res          % attempt < 1000: infinite loop protection
                if attempt == 0
                    eOPSaving;
                    res = SaveOPTable(glob_findin,OPTableNames(eOPind).Prj,OPTableNames(eOPind).SubjGr,eOPTable);
                    s = 1;
                    eOPIdle;
                else
                    answer = uiquestion(C_MSG_OPTABLECHANGED_SAVE_ERR_Q,C_MSG_OPTABLECHANGED_SAVE_ERR_TITLE, ...
                        'SAVEAS',C_MSG_OPTABLECHANGED_SAVEAS, ...
                        'CANCEL',C_MSG_OPTABLECHANGED_CANCEL);
                    switch answer
                        case 'SAVEAS'
                            s = 1;
                            [newfile newpath] = uiputfile(C_MSG_OPTABLECHANGED_EXTTYPES,C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE,defname);
                            if ~isnumeric(newfile)
                                [~, ~, e] = fileparts(newfile);
                                if strcmpi(e,'')
                                    % if no extension, add the first
                                    % default extension
                                    [~, ~, ee] = fileparts(C_MSG_OPTABLECHANGED_EXTTYPES{1});
                                    newfile = strcat(newfile,ee);
                                end;
                                defname = strcat(newpath,newfile);
                                eOPSaving;
                                res = SaveOPTableFN(defname,eOPTable);
                                eOPIdle;
                            else
                                res = 0;
                            end;
                        case 'CANCEL'
                            s = 0;
                            res = 1;
                    end % switch answer
                end; % if attempt == 0
                attempt = attempt + 1;
            end; % while
            if s
                eOPUnChanged
            end;
        end

        function allcallback(hObject, eventdata, handles)
            eOPWorking;
            for i = 1:numel(eOPTable)
                if ~strcmpi(eOPTable(i).Func,'') && ~isempty(eOPTable(i).Func)
                    for j = 1:numel(eOPTable(i).eid)
                        if hObject == eOPTable(i).eid(j)
                            break;
                        end;
                    end;
                    if hObject == eOPTable(i).eid(j)
                        break;
                    end;
                else
                    break;
                end;
            end;
            if hObject ~= eOPTable(i).eid(j)
                return;
            end;

            
            UNDOptr = UNDOptr + 1;

            switch j
                case {1,2,3,4,5}
                    UNDOdata(UNDOptr).COM = 111;
                    UNDOdata(UNDOptr).POS1 = i;
                    UNDOlines(UNDOptr) = eOPTable(i);
                    update_eOP(i,j);
                case 6  % INS
                    UNDOdata(UNDOptr).COM = j;
                    UNDOdata(UNDOptr).POS1 = i;
                    clear_eOP;
                    insert_eOP(i);
                    fetch_eOP;
                case 7  % DEL
                    UNDOdata(UNDOptr).COM = j;
                    UNDOdata(UNDOptr).POS1 = i;
                    UNDOlines(UNDOptr) = eOPTable(i);
                    clear_eOP;
                    delete_eOP(i);
                    fetch_eOP;
                case 8  % UP
                    UNDOdata(UNDOptr).COM = j;
                    UNDOdata(UNDOptr).POS1 = i;
                    UNDOdata(UNDOptr).POS2 = i-1;
                    clear_eOP;
                    swap_eOP(i,i-1);
                    fetch_eOP;
                case 9  % DOWN
                    UNDOdata(UNDOptr).COM = j;
                    UNDOdata(UNDOptr).POS1 = i;
                    UNDOdata(UNDOptr).POS2 = i+1;
                    clear_eOP;
                    swap_eOP(i,i+1);
                    fetch_eOP;
            end;
            
            eOPIdle;

        end
        
        function [s] = SAVEorNOT()
            if UNDOptr == 0
                s = 1;
                return;
            else
                res = 0; attempt = 0;
                if strcmpi(OPTableNames(eOPind).SubjGr,'')
                    defname = strcat(glob_findin,sprintf(C_OPTABLE_FILENAME_FORMAT_WO_SUBJGR,OPTableNames(eOPind).Prj));
                else
                    defname = strcat(glob_findin,sprintf(C_OPTABLE_FILENAME_FORMAT,OPTableNames(eOPind).Prj,OPTableNames(eOPind).SubjGr));
                end;
                while (attempt < 1000) && ~res          % attempt < 1000: infinite loop protection
                    if attempt == 0
                        answer = uiquestion(C_MSG_OPTABLECHANGED_Q,C_MSG_OPTABLECHANGED_TITLE, ...
                            'SAVE',C_MSG_OPTABLECHANGED_SAVE, ... 
                            'SAVEAS',C_MSG_OPTABLECHANGED_SAVEAS, ...
                            'REJECT',C_MSG_OPTABLECHANGED_REJECT, ...
                            'CANCEL',C_MSG_OPTABLECHANGED_CANCEL);
                    else
                        answer = uiquestion(C_MSG_OPTABLECHANGED_SAVE_ERR_Q,C_MSG_OPTABLECHANGED_SAVE_ERR_TITLE, ...
                            'SAVEAS',C_MSG_OPTABLECHANGED_SAVEAS, ...
                            'REJECT',C_MSG_OPTABLECHANGED_REJECT, ...
                            'CANCEL',C_MSG_OPTABLECHANGED_CANCEL);
                    end;
                    attempt = attempt + 1;
                    switch answer
                        case 'SAVE'
                            s = 1;
                            res = SaveOPTable(glob_findin,OPTableNames(eOPind).Prj,OPTableNames(eOPind).SubjGr,eOPTable);
                        case 'SAVEAS'
                            s = 1;
                            [newfile newpath] = uiputfile(C_MSG_OPTABLECHANGED_EXTTYPES,C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE,defname);                    
                            if ~isnumeric(newfile)
                                [~, ~, e] = fileparts(newfile);
                                if strcmpi(e,'')
                                    % if no extension, add the first
                                    % default extension
                                    [~, ~, ee] = fileparts(C_MSG_OPTABLECHANGED_EXTTYPES{1});
                                    newfile = strcat(newfile,ee);
                                end;
                                defname = strcat(newpath,newfile);
                                res = SaveOPTableFN(defname,eOPTable);
                            else
                                res = 0;
                            end;
                        case 'REJECT'
                            s = 1;
                            res = 1;
                        case 'CANCEL'
                            s = 0;
                            res = 1;
                    end % switch answer
                end; % while
            end; % if UNDOptr
        end % func SAVEorNOT
            
        function Left_callback(hObject, eventdata, handles)
            if eOPind > 1
                if SAVEorNOT
                    LoadeOPTable(eOPind-1);
                end;
            end;
        end
            
        function Right_callback(hObject, eventdata, handles)
            if eOPind < OPTableSize
                if SAVEorNOT
                    LoadeOPTable(eOPind+1);
                end;
            end;
        end
        
        function First_callback(hObject, eventdata, handles)
            if SAVEorNOT
                LoadeOPTable(1);
            end;
        end

        function Last_callback(hObject, eventdata, handles)
            if SAVEorNOT
                LoadeOPTable(OPTableSize);
            end;
        end
        
        function New_callback(hObject, eventdata, handles)
            [nOPt nPrj nSubjGr] = dialog_OPTableNew;
            if ~isempty(nOPt)
                % load nOPt -> OPTables(end)
                OPTableSize = OPTableSize + 1;
                OPTableNames(OPTableSize).FileName = C_DI_EOP_UNSAVED; % XOK C_DD... 20120227
                OPTableNames(OPTableSize).Prj = nPrj;
                OPTableNames(OPTableSize).SubjGr = nSubjGr;
                OPTables(OPTableSize,:) = nOPt(:);
                Last_callback;  % simulate 'Last' button click because the 
                                % new OP-table is loaded into the last position
                set(BtnSave,'Enable','on');
                % eOPChanged not working here, we have to enable the
                % 'Save' button only
            end;
        end

        function SaveAs_callback(hObject, eventdata, handles)
            res = 0; attempt = 0; s = 0;
            if strcmpi(OPTableNames(eOPind).SubjGr,'')
                defname = strcat(glob_findin,sprintf(C_OPTABLE_FILENAME_FORMAT_WO_SUBJGR,OPTableNames(eOPind).Prj));
            else
                defname = strcat(glob_findin,sprintf(C_OPTABLE_FILENAME_FORMAT,OPTableNames(eOPind).Prj,OPTableNames(eOPind).SubjGr));
            end;
            while (attempt < 1000) && ~res          % attempt < 1000: infinite loop protection
                s = 1;
                [newfile newpath] = uiputfile(C_MSG_OPTABLECHANGED_EXTTYPES,C_MSG_OPTABLE_NEWFILE,defname);
                if ~isnumeric(newfile)
                                [~, ~, e] = fileparts(newfile);
                                if strcmpi(e,'')
                                    % if no extension, add the first
                                    % default extension
                                    [~, ~, ee] = fileparts(C_MSG_OPTABLECHANGED_EXTTYPES{1});
                                    newfile = strcat(newfile,ee);
                                end;
                    defname = strcat(newpath,newfile);
                    eOPSaving;
                    res = SaveOPTableFN(defname,eOPTable);
                    eOPIdle;
                else
                    res = 1;
                end;
                attempt = attempt + 1;
            end; % while
%            if s
 %               eOPUnChanged
  %          end;
        end % function SaveAs_callback

    end % func dialog_OPTableEditor

    function [res] = SaveOPTable(path, prjname, subjgr, OPTableData)
        if strcmpi(subjgr,'')
            fn = strcat(path,sprintf(C_OPTABLE_FILENAME_FORMAT_WO_SUBJGR,prjname));
        else
            fn = strcat(path,sprintf(C_OPTABLE_FILENAME_FORMAT,prjname,subjgr));
        end;
        
        res = SaveOPTableFN(fn, OPTableData);
    end % func SaveOPTable
    
    function [res] = SaveOPTableFN(fn, OPTableData)
        if exist(fn,'file')                         % get&store user data
            [ofh, msg] = fopen(fn);
            if ofh == -1
                errodlg({C_MSG_EOP_ERRORSAVING,fn,msg},C_MSG_EOP_ERRORSAVING_TITLE,'modal');
                res = 0; 
                return;
            end;
            try
                sBefore = ''; sAfter = '';
                s = '';
                while ischar(s) && ~strcmp(strtrim(s),strtrim(C_OPTABLE_BEGIN))
                    sBefore = [sBefore,s];
                    s = fgets(ofh);
                end;
                if strcmpi(strtrim(sBefore),'')
                    sBefore = [C_OPTABLE_BEGIN,13,10];
                else
                    sBefore = [sBefore,C_OPTABLE_BEGIN,13,10];
                end;
                while ischar(s) && ~strcmp(strtrim(s),strtrim(C_OPTABLE_END))
                    s = fgets(ofh);
                    % drop s
                end;
                s = [C_OPTABLE_END,13,10];
                while ischar(s)
                    sAfter = [sAfter,s];
                    s = fgets(ofh);
                end;
                if strcmpi(strtrim(sAfter),C_OPTABLE_END)
                    sAfter = C_OPTABLE_END;
                end; % what if no optablestart/optableend
            catch exception
                fclose(ofh);
                errodlg({C_MSG_EOP_ERRORSAVING,fn,char(exception.message)},C_MSG_EOP_ERRORSAVING_TITLE,'modal');
                res = 0; 
				if VAR_ThrowExceptions,	rethrow(exception); end;

                return;
            end;
            
            fclose(ofh);
            
            [d1 n1 e1] = fileparts(fn);             % save backup
            d2 = d1; e2 = e1;
			
			n2 = strcat(n1,e1);
			opt_pos = strfind(lower(n2),lower(C_OPTABLE_POSTFIX));
			if numel(opt_pos) > 1
				opt_pos = opt_pos(1);
			end;
			n2 = [ n2(1:opt_pos-1) C_OPTABLE_BACKUP n2(opt_pos+numel(C_OPTABLE_POSTFIX):end) ]; % v0.1.019

            fn2 = strcat(d2,n2);
            [copystatus] = copyfile(fn,fn2);

        else % if not exist
            sBefore = [C_OPTABLE_BEGIN,13,10];
            sAfter = [C_OPTABLE_END];
        end; % if
        [ofh,msg] = fopen(fn,'w');                  % save userdata&optable data
        if ofh == -1
            errodlg({C_MSG_EOP_ERRORSAVING,fn,msg},C_MSG_EOP_ERRORSAVING_TITLE,'modal');
            res = 0;
            return;
        end;
        try
            fwrite(ofh,sBefore);
            
            for i = 1:numel(OPTableData)
                if isempty(OPTableData(i).Func) || strcmpi(OPTableData(i).Func,'')
                    % OPTable end mark
                    break;
                end;
                [ements] = PackOPTableLine(OPTableData(i));
                if numel(ements) > 0 % Note: could have used sprintf here also
                    concat = ements{1}; % v0.2.002 char( removed
                    for j = 2:numel(ements)
                        concat = [concat,09,ements{j}]; % v0.2.002 char( removed
                    end;
                    concat = [concat,13,10];
                    fwrite(ofh,concat);
                end;
            end;
                    
            fwrite(ofh,sAfter);
        catch exception
            fclose(ofh);
            errodlg({C_MSG_EOP_ERRORSAVING,fn,char(exception.message)},C_MSG_EOP_ERRORSAVING_TITLE,'modal');
            res = 0; 
			if VAR_ThrowExceptions,	rethrow(exception); end;
            return;
        end;
            
        fclose(ofh);
        
        res = 1;

    end
        

%     function [answer] = uiquestion(qstr, qtitle, varargin)
% 
%         hWnd = dialog('WindowStyle','normal','Name',qtitle,'Units','Normalized','Position',[.40 .40 .2 .2]);
%         uicontrol(hWnd,'Style','text','String',qstr,'HorizontalAlignment','center','Units','Normalized','Position',[.05 .5 .9 .45]);
% 
%         answer = '';
% 
%         nbuttons = (nargin-2)/2;
% 
%         for k=1:2:nbuttons*2
%             uicontrol(hWnd,'Style','pushbutton','String',varargin{k+1},'Tag',varargin{k},'callback',@allbtncallback,'Units','Normalized', ...
%                 'Position', [.05+((k-1)/2*(.9/nbuttons)) .125 (0.9/nbuttons)*0.9 .25]);
%         end
% 
%         waitfor(hWnd);
% 
%             function allbtncallback(hObject, eventdata, handles)
%                 answer = get(hObject,'Tag');
%                 delete(get(hObject,'parent'));
%             end
% 
%     end
	
    function dialog_PluginEditor()

        PluginEditor = dialog('WindowStyle','normal','Name',C_DI_PLUGINEDITOR_CAPTION);

        LbPrefix = uicontrol(PluginEditor,'style','text','units','normalized','Position',[0 .70 .70 .1],'HorizontalAlignment','left', ...
            'FontWeight','bold', ...
            'string','<later>');
        uicontrol(PluginEditor,'style','text','units','normalized','Position',[.70 .70 .29 .30], ...
            'HorizontalAlignment','left','FontAngle','italic','ForegroundColor',[.5 .5 .5], ...
            'string',C_DI_HELP1);
        uicontrol(PluginEditor,'style','text','units','normalized','Position',[.70 0 .29 .30], ...
            'HorizontalAlignment','left','FontAngle','italic','ForegroundColor',[.5 .5 .5], ...
            'string',C_DI_HELP2);
        LbPostfix = uicontrol(PluginEditor,'style','text','units','normalized','Position',[0 0 .70 .28],'HorizontalAlignment','left', ...
            'FontWeight','bold', ...
            'string',C_DI_PE_POSTFIX);
        EdMain = uicontrol(PluginEditor,'style','edit','units','normalized','Position',[0 .30 .80 .40], ...
            'HorizontalAlignment','left','min',1,'max',numel(C_DI_PE_BODY),'string', C_DI_PE_BODY);
        uicontrol(PluginEditor,'style','text','units','normalized','Position',[.82 .63 .15 .05], ...
            'string',C_DI_PLUGINEDITOR_PLUGINNAME,'HorizontalAlignment','left');
        EdName = uicontrol(PluginEditor,'style','edit','units','normalized','Position',[.82 .60 .15 .05], ...
            'string','probaplugin','callback',@Updatelabels_callback);
        uicontrol(PluginEditor,'style','text','units','normalized','Position',[.82 .53 .15 .05], ...
            'string',C_DI_PLUGINEDITOR_PLUGINPARAMS,'HorizontalAlignment','left');
        EdParams = uicontrol(PluginEditor,'style','edit','units','normalized','Position',[.82 .50 .15 .05], ...
            'string','param1,param2','callback',@Updatelabels_callback);
        BtnPluginSave = uicontrol(PluginEditor,'style','pushbutton','units','normalized','Position',[.82 .40 .15 .08], ...
            'string',C_DI_PLUGINEDITOR_SAVE,'callback',@callback_PEsave);

        updatelabels;
        
        function updatelabels
            set(LbPrefix,'string',sprintf(C_DI_PLUGINEDITOR_FUNCTIONFORMAT,get(EdName,'string'),strcat(',',get(EdParams,'string'))));
        end
        
        function Updatelabels_callback(hObject, eventdata, handles)
            updatelabels;
        end
        
        function callback_PEsave(hObject, eventdata, handles)
            updatelabels;
            if strcmpi(get(EdName,'string'),'')
                errordlg(C_MSG_PE_CANNOTSAVEEMPTYNAME,C_MSG_PE_ERRORSAVING_Title,'modal');
                return;
            end;
            plugin_fullpath = strcat(glob_findin,get(EdName,'string'),'.M');
            [pfh, msg] = fopen(plugin_fullpath,'w');
            if pfh == -1
                errordlg({C_MSG_PE_ERRORSAVING,plugin_fullpath,msg},C_MSG_PE_ERRORSAVING_Title,'modal');
                return;
            end;
            try
                fwrite(pfh,strcat(get(LbPrefix,'string'),13,10));
                s = get(EdMain,'string');
                for i = 1:numel(s)
                    fwrite(pfh,strcat(s{i},13,10));
                end;
                fwrite(pfh,strcat(get(LbPostfix,'string'),13,10));
            catch exception
				fclose(pfh); pfh = 0; % v0.1.023
                errordlg({C_MSG_PE_ERRORSAVING,plugin_fullpath,char(exception.message)},C_MSG_PE_ERRORSAVING_Title,'modal');
				if VAR_ThrowExceptions,	rethrow(exception); end;
            end;
            if pfh > 0
				fclose(pfh);
			end;
        end % func callback_PEsave
    
    end        

% --------- ETA, managetimers, computerID ---------
%		function [s] = computerID
%	    function managetimers
%	    function ETAreset
%	    function ETAupdate


	function [s] = computerID
		s = lower(getenv('COMPUTERNAME'));
	end;

    function managetimers
        c = clock;
        if (VAR_RunTimer > 0)
            nightrun = 0;
            for nightrun_i=1:3
                if VAR_RunTimerStart(nightrun_i) > VAR_RunTimerEnd(nightrun_i)
                    nightrun = 1;
                    break;
                elseif VAR_RunTimerStart(nightrun_i) < VAR_RunTimerEnd(nightrun_i)
                    break;
                end; 
            end;
            
            if VAR_WeekendRun > 0
                if (weekday(datenum(c)) == 7) || ...
                   (weekday(datenum(c)) == 1)
                    weekendrun = 1;
                else
                    weekendrun = 0;
                end;
            else
                weekendrun = 0;
            end;
            
            if (((nightrun>0) && ((c(4:6)*[3600 60 1]' <= VAR_RunTimerStart*[3600 60 1]') && (c(4:6)*[3600 60 1]' >= VAR_RunTimerEnd*[3600 60 1]'))) || ...
               ((nightrun==0) && ((c(4:6)*[3600 60 1]' <= VAR_RunTimerStart*[3600 60 1]') || (c(4:6)*[3600 60 1]' >= VAR_RunTimerEnd*[3600 60 1]')))) && ...
               not(weekendrun)
                    aLog(sprintf(C_MSG_TIMER_HLT,VAR_RunTimerStart));
                    waitTimer = timer('TasksToExecute',1,'TimerFcn',@waittimer_nope_callback,'StartDelay',((VAR_RunTimerStart-c(4:6))*[3600 60 1]'));
                    start(waitTimer); wait(waitTimer); waitTimer = 0;
                    aLog(sprintf(C_MSG_TIMER_REST,VAR_RunTimerStart));
                    cooldown_rs = clock; % don't start with cooldown
            end;
        end;
        if (VAR_CooldownTimer_Enabled > 0)
            if (cooldown_rs == zeros(1,6))
                cooldown_rs = clock;
            end;
            timesince = clock-cooldown_rs;
            if (timesince*[31000000 2500000 68400 3600 60 1]') >= (VAR_CooldownTimer_Interval*[3600 60 1]')
                aLog(sprintf(C_MSG_COOLDOWN_HLT,VAR_CooldownTimer_Duration));
                waitTimer = timer('TasksToExecute',1,'TimerFcn',@waittimer_nope_callback,'StartDelay',VAR_CooldownTimer_Duration*[3600 60 1]');
                start(waitTimer); wait(waitTimer); waitTimer = 0;
                fxc = fix(clock);
                aLog(sprintf(C_MSG_COOLDOWN_REST,fxc(4:6)));
                cooldown_rs = clock; 
            end;
        end;
    end % managetimers
	
    function ETAreset
		% initializes ETA at the start of round
		round_start = clock; 
        set(LbETA,'string','ETA: --:--:--');
    end

    function ETAupdate
        round_now = clock;
		elapsed = round_now-round_start;
		elapsed = elapsed(3:6)*[86400 3600 60 1]';
		if DIthingsdone > 0
			alltime = elapsed/DIthingsdone*DIthingstodo;
			start_sec = round_start(4:6)*[3600 60 1]';
			end_sec = start_sec+alltime;
			set(LbETA,'string',sprintf(C_DI_ETA_FORMAT,DIthingsdone+1,DIthingstodo,floor(end_sec/3600),floor(mod(end_sec,3600)/60),floor(mod(end_sec,60))));
		else
			set(LbETA,'string',sprintf(C_DI_ETA_FORMAT,DIthingsdone+1,DIthingstodo,0,0,0));
		end;
	end
%
%
%
% -------------- MUTEX HANDLING -------------------
%		function [OK] = FSMutexCreate(fn)
%		function [OK] = FSMutexDelete(fn,cleanup)
%		function [OK, owner] = FSMutexCheck(fn)
%		function [cleared, owners] = ResetMutex(dirpath,cleanup)
%		function [lockfn] = mutexSTART(fn)
%		function mutexEND(fn)
%		function mutexHOLD(dirpath,usertoo,opt_ratio_ena)
%		function mutexRELEASE

	function [OK] = FSMutexCreate(fn)
		% obs fclose(fopen(fn,'w')); % fclose(fopen()) = fcreate, see also EEGbatch.mutexSTART
		fh = fopen(fn,'w');
		if ~exist(fn,'file')
			if fh > 0 
				fclose(fh);
			end;
			ME = MException('EEGbatch:FS_MUTEX_FATAL_CR',C_MSG_FSMUTEX_NOCREATE,fn);
			throw(ME);
		end;
		if fh <= 0
			ME = MException('EEGbatch:FS_MUTEX_FATAL_CR2',C_MSG_FSMUTEX_NOCREATE2,fn);
			throw(ME);
		end;
		try
			fprintf(fh,'%s',computerID);
		catch exception
			fclose(fh);
			rethrow(exception);
		end;
		fclose(fh);
	end % func FSMutexCreate
	
	function [OK] = FSMutexDelete(fn,cleanup)
		if nargin < 2
			cleanup = 0;
		end;
		if ~exist(fn,'file')
			ME = MException('EEGbatch:FS_MUTEX_FATAL_DE',C_MSG_FSMUTEX_NOTEXIST,fn);
			throw(ME);
		end;
		[OK, owner] = FSMutexCheck(fn);
		if OK && ~cleanup
			ME = MException('EEGbatch:FS_MUTEX_FATAL_DE3',C_MSG_FSMUTEX_DIFFOWNER,fn,owner);
			throw(ME);
		end;
		delete(fn);
		if exist(fn,'file')
			ME = MException('EEGbatch:FS_MUTEX_FATAL_DE2',C_MSG_FSMUTEX_NODELETE,fn);
			throw(ME);
		end;
	end % func FSMutexDelete
	
	function [OK, owner] = FSMutexCheck(fn)
		OK = exist(fn,'file');
		if OK 
			fh = fopen(fn,'r');
			try
				s = fgets(fh);
			catch exception
				fclose(fh);
				rethrow(exception);
			end;
            fclose(fh);
			if isnumeric(s)
				ME = MException('EEGbatch:FS_MUTEX_FATAL_CHK',C_MSG_FSMUTEX_NOOWNER,fn);
				throw(ME);
			end;
			owner = strtrim(lower(s));
			if strcmpi(owner,strtrim(computerID))
				OK = 0;
			end;
		else
			owner = '';
		end;
	end % func FSMutexCheck
	
	function [cleared, owners] = ResetMutex(dirpath,cleanup)
		if dirpath(end) ~= '\'
			dirpath = strcat(dirpath,'\');
		end;
		if nargin < 2
			cleanup = 0;
		end;
		mtxlist = dir(strcat(dirpath,'*.lock'));
		cleared = 0;
		ownerscnt = 0; owners = [];
		for i = 1:numel(mtxlist)
			[OK, owner] = FSMutexCheck(strcat(dirpath,mtxlist(i).name));
			if cleanup || (abs(now - mtxlist(i).datenum) >= C_LOSTMUTEX_DAYS)
				FSMutexDelete(strcat(dirpath,mtxlist(i).name),1);
				if ownerscnt == 0
					owners = cell(1,1);
					owners{1} = lower(owner);
				else
					for ii = 1:numel(owners)
						if strcmpi(owner,owners{ii})
							break;
						end;
					end;
					if ~strcmpi(owner,owners{ii})
						owners{numel(owners)+1} = lower(owner);
					end;
				end; % if ownerscnt
				cleared = cleared + 1;
			else % if not cleanup
				if ~OK
					FSMutexDelete(strcat(dirpath,mtxlist(i).name),0);
					cleared = cleared + 1;
				end;
			end;
		end; % for i 
		if cleared > 0
			others = 0;
			if ~isempty(owners)
				ccowners = '';
				for i = 1:numel(owners)
					if ~strcmpi(owners{i},computerID)
						ccowners = [ ccowners owners{i} ', ' ];
						others = 1;
					end;
				end;
				if numel(ccowners) > 2
					ccowners = ccowners(1:end-2);
				end;
			end;
			if others
				aLog(sprintf(C_MSG_MTXCLEARED2,cleared,ccowners));
			else
				aLog(sprintf(C_MSG_MTXCLEARED,cleared));
			end;
		end;
	end % func ResetMutex

    % tries to hold a mutex (lockfile) for the given file preventing other 
	% instances to work on that file while we're working 
    % lockfn is the lock file name created
    function [lockfn] = mutexSTART(fn)
		% v0.2.002 char(fn) removed everywhere in this function
        fn = strcat(fn,'.lock'); 
        if VAR_MutexEnabled
            if ~FSMutexCheck(fn) 
				FSMutexCreate(fn); 
                lockfn = fn;
                xLog(['MTX: holding ' fn]);
            else
                lockfn = '';
                xLog(['MTX: cannot hold ' fn]);
            end;
        else
            lockfn = fn;
        end;
    end % mutexSTART

    function mutexEND(fn)
		% v0.2.002 char(fn) removed everywhere in this function
        if VAR_ExtendedLog
            if exist(fn,'file')
                xLog(['MTX: releasing ' fn]);
            else
                xLog(['MTX: ?? not found ' fn]);
            end;
        end;
        FSMutexDelete(fn);
    end % mutexEND

    function mutexHOLD(dirpath,usertoo,opt_ratio_ena)
        %   opt_ratio_all               all the tasks that have READY state in the list (despite this they will not
		%                               be started based on cross-computer optimization or locked by mutex file)
		%	DEBUG_opt_ratio_skipped		counts those skipped from the list above because of cross-computer optimization 
		%                               (their state will now be OPTMANAGEMENT)
		%	DEBUG_opt_ratio_mutexed		counts those already started by other computers (they're locked by a mutex)
		%   opt_ratio_planned			target number of tasks to complete on this machine, its value is
		%									opt_ratio_all * opt_ratio_perf/100 * VAR_OptRatio_Roundup
		%                               [opt_ratio_all used here (instead of e.g. (opt_ratio_all-mutexed)) because
		%                               that would cause unwanted further multiplication of available tasks resulting
		%                               in wrong answer. What we want here is to take a fixed percent of all the 
		%                               available and waiting tasks and run them.]
		%                               [opt_ratio_perf/100: this is the percentage, calculated by the different 
		%                               computers' relative performance]
		%                               [VAR_OptRatio_Roundup: around 1.1 -- it provides that to task will be left out
		%                               because of some rounding down in the the tasks assigned to different computers]
		%	opt_ratio_ena				0 indicates we're in USER mode, so we'll ignore the PI component and start 
		%                               everything that's available
		%	opt_ratio_current			it's meaningful only in the main loop, counting how many actual tasks we've 
		%                               managed to start (those that were READY and unmutexed), and it stops counting if
		%                               it reaches opt_ratio_planned and sets opt_ratio_reached to true then [unless
		%                               opt_ratio_ena is false which turns off this logic and lets this instance take
		%                               all the available tasks]
		%	opt_ratio_reached			it is set to true if opt_ratio_current reaches opt_ratio_planned [but only if
		%                               opt_ratio_ena is true] and causes this instance of EEGbatch to stop taking tasks
        opt_ratio_all = 0; DEBUG_opt_ratio_skipped = 0; DEBUG_opt_ratio_mutexed = 0;
		
		% calculate opt_ratio_all
        for i = 1:DITableSize
            if (DITable(i).Status == DIS_READY) && ...
				(((usertoo == PDI_AUTOMODE) && (DITable(i).AutoFN == 1)) || ...
				((usertoo == PDI_USERONLY) && (DITable(i).AutoFN == 0)) || ...
				(usertoo == PDI_USERMODE)) % v0.2.002
                opt_ratio_all = opt_ratio_all + 1;
            end;
        end;
		
        opt_ratio_planned = opt_ratio_all * opt_ratio_perf * VAR_OptRatio_Roundup / 100;
		opt_ratio_planned = floor(opt_ratio_planned)+1; % v0.1.016
		if opt_ratio_planned > opt_ratio_all % v0.1.016
			opt_ratio_planned = opt_ratio_all;
		end;
        opt_ratio_current = 0; opt_ratio_reached = 0;
                xLog(sprintf('PI/MTX: found %u ready\tplanned ratio: %u/%u',opt_ratio_all,opt_ratio_planned,opt_ratio_all-opt_ratio_planned));
        for i = 1:DITableSize % main loop
            if DITable(i).Status ~= DIS_READY % we're dealing with READY state tasks only
                continue;
            end;
			if ((usertoo == PDI_AUTOMODE) && (DITable(i).AutoFN == 0)) || ...
				((usertoo == PDI_USERONLY) && (DITable(i).AutoFN == 1)) % v0.2.002
				continue;
			end;
            if opt_ratio_reached % if opt_ratio_planned is reached, skip the rest
                DITable(i).Status = DIS_OPTMANAGEMENT; DEBUG_opt_ratio_skipped = DEBUG_opt_ratio_skipped + 1;
            else % still gathering
				% have anyone assigned to it yet?
                DITable(i).mtxid = cell(1,numel(DITable(i).InFile));
                for ii = 1:numel(DITable(i).InFile) % mutex-check-hold
                    DITable(i).mtxid{ii} = mutexSTART(strcat(dirpath,DITable(i).InFile{ii}));
                    if strcmpi(DITable(i).mtxid{ii},'')
                        DITable(i).Status = DIS_MUTEXERROR; DEBUG_opt_ratio_mutexed = DEBUG_opt_ratio_mutexed + 1; 
                        for iii = ii-1:-1:1 % clear mutexes
                            mutexEND(DITable(i).mtxid{iii});
                        end;
                        DITable(i).mtxid = {};
                        break;
                    end; % if strcmpi(mtxid,'')
                end; % for ii
				% we skip the task if anyone else working on it (thus had a MUTEXERROR state in loop ii
                if DITable(i).Status ~= DIS_MUTEXERROR
                    opt_ratio_current = opt_ratio_current + 1; % otherwise increase opt_ratio_current
                end; 
                if (opt_ratio_current > opt_ratio_planned) && (opt_ratio_ena)
                    opt_ratio_reached = 1;
                end;
            end; % if opt_ratio_reached
        end; % for i
        if opt_ratio_ena
			% this is NOT xLog:
            vLog(sprintf(C_MSG_OPT_RATIO_INFOLINE1,floor(opt_ratio_planned),opt_ratio_all,DEBUG_opt_ratio_skipped,DEBUG_opt_ratio_mutexed));
			% displaying opt_ratio_planned, opt_ratio_all, opt_ratio_skipped, opt_ratio_mutexed
        else
			% this is NOT xLog:
            vLog(sprintf(C_MSG_OPT_RATIO_INFOLINE2,floor(opt_ratio_planned),opt_ratio_all,DEBUG_opt_ratio_skipped,DEBUG_opt_ratio_mutexed));
			% displaying opt_ratio_planned, opt_ratio_all, opt_ratio_skipped, opt_ratio_mutexed
        end;
        if VAR_ExtendedLog
            % xLog the sums
            L_already = ''; L_ready = '';
            L_mutexed = ''; L_manage = '';
            L_mtxcount = 0;
            for i = 1:DITableSize
                switch DITable(i).Status
                    case DIS_ALREADYDONE
                        L_already = [L_already '///' DITable(i).InFile{1}]; % v0.2.002 char( removed
                    case DIS_READY
                        L_ready = [L_ready '///' DITable(i).InFile{1}];
                    case DIS_MUTEXERROR
                        L_mutexed = [L_mutexed '///' DITable(i).InFile{1}];
                    case DIS_OPTMANAGEMENT
                        L_manage = [L_manage '///' DITable(i).InFile{1}];
                end;
                L_mtxcount = L_mtxcount + numel(DITable(i).mtxid);
            end; % for
            L_already = L_already(4:end); L_ready = L_ready(4:end);
            L_mutexed = L_mutexed(4:end); L_manage = L_manage(4:end);
            xLog(strcat('PI/MTX: alreadydone : ',L_already)); % v0.2.002 char( removed
            xLog(strcat('PI/MTX: ready       : ',L_ready));
            xLog(strcat('PI/MTX: mutexed     : ',L_mutexed));
            xLog(strcat('PI/MTX: manage      : ',L_manage));
            xLog(sprintf('PI/MTX: %u active mutexes',L_mtxcount));
        end;
    end % func mutexHOLD

    function mutexRELEASE
        if VAR_MutexEnabled
            for i = 1:DITableSize
                if ~isempty(DITable(i).mtxid)
                    for ii = 1:numel(DITable(i).mtxid)
                        if ~strcmpi(DITable(i).mtxid{ii},'')
                            mutexEND(DITable(i).mtxid{ii});
							DITable(i).mtxid{ii} = ''; % v0.1.016
                        end;
                    end;
                end;
            end;
        end;
    end
%
%
%	
% --------------- Performance Index ---------------
%
%
%
    function [opt_percent myPI PERFtable] = EEGbatch_perfindex(glob_findin, hideME, noRECALC)

		if not(VAR_PerfInd_Enabled)
			opt_percent = 100;
			return;
		end;
        myPOS = 0; totalperf = 0; 
        PERFtable(1) = struct('ID','','PI',0,'MF',0,'TS',0,'FP',0);
        % ID: computername, PI: performance index
        % MF: multiplier, TS: timestamp of PI, FP: footprint timestamp
        
        myPI = 0; myTS = 0; myID = ''; myMF = 0; myFP = 0; PERFtableMOD = 0;

        datname = strcat(glob_findin,C_PI_DATNAME);
        mtxname = strcat(glob_findin,C_PI_DATNAME,'.lock');

        function getmypos_perfindex()
            for i = 1:numel(PERFtable)
                if strcmpi(myID,PERFtable(i).ID)
                    break;
                end;
            end;
            if strcmpi(myID,PERFtable(i).ID)
                myPOS = i;
            else
                myPOS = 0;
            end;
        end

        function getdata_perfindex()
            myID = computerID;
            myTS = now;
            myFP = now;
        end

        function recalc_perfindex()
            vLog(C_MSG_CALCULATING_PI);
            
            MeasureFactor = C_PI_STARTMEASURE_FACTOR;
            elapsed = 0;

            while elapsed < 1
                testdata = rand(1,MeasureFactor);
                tic;
                for i = 1:MeasureFactor
                    testdata(i) = sin(testdata(i));
                end;
                elapsed = toc;
                if elapsed < 1
                    MeasureFactor = MeasureFactor * C_PI_MF_MULTIPLIER;
                end;
            end;

            myPI = 1/(elapsed * 10000 / MeasureFactor);
            myMF = log10(MeasureFactor);
        end % func recalc_perfindex;

        function read_perfindex()
            if exist(datname,'file')
                if VAR_PerfInd_MutexEnabled
                    tic;
                    if FSMutexCheck(mtxname)
                        vLog(sprintf(C_MSG_PI_MTX_WAITING,C_PI_DATNAME,C_PI_MUTEX_MAXWAIT));
                    end;
                    while (toc < C_PI_MUTEX_MAXWAIT) && FSMutexCheck(mtxname)
                        % nope
                    end;
                    if ~FSMutexCheck(mtxname)
						FSMutexCreate(mtxname); 
                    else
                        ME = MException('EEGbatch:PERFINDEX:MUTEXERROR',C_MSG_PERFINDEXMUTEXERROR,C_PI_DATNAME);
                        throw(ME);
                    end;
                end;
                PT = load(datname,'PERFtable');
                PERFtable = PT.PERFtable;
            else
                PERFtable(1) = struct('ID','','PI',0,'MF',0,'TS',0,'FP',0);
                PERFtableMOD = 0;
				if VAR_PerfInd_MutexEnabled % v0.1.022
					FSMutexCreate(mtxname); % v0.1.016
				end;
            end;
        end

        function store_perfindex()
            if PERFtableMOD
                if hideME && (myPOS > 0)
                    PERFtable(myPOS) = [];
                end;
                save(datname,'PERFtable');
            end;
            if VAR_PerfInd_MutexEnabled
                FSMutexDelete(mtxname);
            end;
        end

        function update_perfindex()
            if (myPOS == 0) || (myTS - PERFtable(myPOS).TS > C_PI_RECALC_INTV)
                recalc_perfindex;
                PERFtableMOD = 1;
                if myPOS == 0
                    if (numel(PERFtable) == 1) && (PERFtable(1).PI == 0)
                        myPOS = 1;
                    else
                        myPOS = numel(PERFtable) + 1;
                    end;
                end;
                if noRECALC
                    myTS = Inf;
                end;
                PERFtable(myPOS).ID = myID;
                if isempty(PERFtable(myPOS).PI) || (PERFtable(myPOS).PI == 0)
                    PERFtable(myPOS).PI = myPI;
                else
                    PERFtable(myPOS).PI = ...
                        (C_PI_AVGFACTOR1*PERFtable(myPOS).PI + ...
                        C_PI_AVGFACTOR2*myPI)* ...
                        (1/(C_PI_AVGFACTOR1+C_PI_AVGFACTOR2));
                end;

                PERFtable(myPOS).MF = myMF;
                PERFtable(myPOS).TS = myTS;
            else
                myPI = PERFtable(myPOS).PI;
                myMF = PERFtable(myPOS).MF;
            end;
            PERFtable(myPOS).FP = myFP;
        end

        function digthedead_perfindex()
            MARKfordel = [];
            for i = 1:numel(PERFtable)
                if myFP - PERFtable(i).FP > C_PI_DEAD_INTV
                    MARKfordel(end+1) = i;
                end;
            end; 
            for i = 1:numel(MARKfordel)
                PERFtable(MARKfordel(i)) = [];
                PERFtableMOD = 1;
            end;
        end

        function calctotal_perfindex()
            totalperf = 0;
            % BUG eliminated: "self-zombie" opt_percent = Inf (totalperf = 0)
            for i = 1:numel(PERFtable)
                if myFP - PERFtable(i).FP <= C_PI_ZOMBIE_INTV
                    totalperf = totalperf + PERFtable(i).PI;
                end;
            end;
            if myPOS == 0
                totalperf = totalperf + myPI;
            end;
        end

    % main
        read_perfindex;
        getdata_perfindex;
        getmypos_perfindex;
        update_perfindex;
        calctotal_perfindex;
        digthedead_perfindex;
        store_perfindex;

        opt_percent = myPI / totalperf * 100;
        
        vLog(sprintf(C_MSG_GOT_PI,opt_percent,myPI,myMF,numel(PERFtable)));

    end

% ---------------- LOGGING -----------------------
%		function [EEG] = dLog(EEG,s)
%		function fLogCondense(dirpath,cleanup)
%		function fLogInit(dirpath)
%		function eLogInit(dirpath)
%		function xLogInit(dirpath)
%		function [OK] = fLog(s)
%		function [pos] = vLog(s)
%		function vLogCLC
%		function vLogAdd(s)
%		function vLogReplace(s)
%		function vLogBackspace
%		function vLogErr(ind,s)
%		function vLogSuspend(s)
%		function vLogSel(pos)
%		function aLog(s)
%		function aLogSuspend(s)
%		function aeLog(s)
%		function [OK] = eLog(s) 
%		function [OK] = xLog(s) 

	% Log->Dataset
    function [EEG] = dLog(EEG,s)
        if VAR_DatasetLogging 
			if VAR_DatasetLogging_UseNewVar
				if isfield(EEG,'EEGbatch_comments')
					EEG.EEGbatch_comments{end+1} = s;
				else
					EEG.EEGbatch_comments{1} = s;
				end;
			elseif VAR_DatasetLogging_UsePopcomments
				EEG.comments = pop_comments(EEG.comments,'',s,1);
			else
				if size(EEG.comments,2) < numel(s)
					EEG.comments = [ [EEG.comments zeros(size(EEG.comments,1),numel(s)-size(EEG.comments,2))]' s' ]';
				else
					EEG.comments = [ EEG.comments' [s zeros(1,size(EEG.comments,2)-numel(s))]'  ]';
				end;
			end;
        end;
    end

    function fLogCondense(dirpath,cleanup)
        if dirpath(end) ~= '\'
            dirpath = strcat(dirpath,'\');
        end;
		if nargin < 2
			cleanup = 0;
		end;
        if FSMutexCheck(strcat(dirpath,C_LOGTOFILE_CONDENSE_MUTEX)) 
            return;
        else
			FSMutexCreate(strcat(dirpath,C_LOGTOFILE_CONDENSE_MUTEX));
        end;
        try % delete mutex
			loglist = dir(strcat(dirpath,C_LOGTOFILE_FILENAME_MASK)); 
            oldest_date = Inf; 
            for i = 1:numel(loglist)
                if ~loglist(i).isdir && (loglist(i).datenum < oldest_date)
                    oldest_date = floor(loglist(i).datenum);
                end; 
            end; % for-if
			
			if cleanup
				stepback = 0;
			else
				stepback = 2;
			end;
			
			try % close fb
				for j = floor(now)-stepback:-1:oldest_date
					fb = 0;
					for i = 1:numel(loglist)
						if (floor(loglist(i).datenum) == j) && ...
						   (~strcmpi(strcat(dirpath,loglist(i).name),logFilename)) % check it's not the current one
						
							if fb == 0
								[fb msg] = fopen(strcat(dirpath,sprintf(C_LOGTOFILE_CONDENSE_FILENAME_FORMAT,year(j),month(j),day(j))),'a');
								if fb <= 0
									aeLog(sprintf(C_MSG_CANNOTCONDENSE,msg,strcat(dirpath,sprintf(C_LOGTOFILE_CONDENSE_FILENAME_FORMAT,year(j),month(j),day(j)))));
								end;
							end;
							
							fa = fopen(strcat(dirpath,loglist(i).name),'r');
							
							try % close fa
								s = fgets(fa);
								while ~isnumeric(s)
									fwrite(fb,s);
									s = fgets(fa);
								end;
							catch exception
								fclose(fa);
								aeLog(sprintf(C_MSG_CANNOTCONDENSE,exception.message,strcat(dispath,loglist(i).name)));
								if VAR_ThrowExceptions 
									rethrow(exception);
								end;
							end;
							
							fclose(fa);
                            delete(strcat(dirpath,loglist(i).name));
						end; % if date matches
					end; % for i
					if fb > 0
						fclose(fb);
					end;
				end; % for j
			catch exception
				if fb > 0
					fclose(fb);
				end;
				aeLog(sprintf(C_MSG_CANNOTCONDENSE,exception.message,strcat(dirpath,sprintf(C_LOGTOFILE_CONDENSE_FILENAME_FORMAT,year(j),month(j),day(j)))));
				if VAR_ThrowExceptions
					rethrow(exception);
				end;
			end; % try
		catch exception
			FSMutexDelete(strcat(dirpath,C_LOGTOFILE_CONDENSE_MUTEX));
			aeLog(sprintf(C_MSG_CANNOTCONDENSE,exception.message,''));
			if VAR_ThrowExceptions
				rethrow(exception);
			end;
		end; % try
        
        FSMutexDelete(strcat(dirpath,C_LOGTOFILE_CONDENSE_MUTEX));
	end % func fLogCondense
                        
	% initializes logging to file, chooses new logfile name
    function fLogInit(dirpath)
        if VAR_LogToFile == -1
			% if it was turned on eariler, just some error occurred,
			% try to turn back on again the logging (failure might
			% be fixed since)
            VAR_LogToFile = 1;
            vLog(C_MSG_FLOGREINIT);
        end;
        if VAR_LogToFile > 0
            [d , ~, ~] = fileparts(logFilename);
            if ~strcmpi(d,'')
                if d(end) ~= '\'
                    d = strcat(d,'\');
                end;
            end;
            if ~strcmpi(d,dirpath) || VAR_SeparateLogFiles
                logFilename = '';
                while strcmpi(logFilename,'') || exist(logFilename,'file')
                    logFilename = strcat(dirpath,sprintf(C_LOGTOFILE_FILENAME_FORMAT,floor(rand * 100000)));
                end;
                vLog(sprintf(C_MSG_NEWLOGFILE,logFilename));
                fLog(sprintf(C_MSG_LOGFILE_INIT,C_EEGBATCH_VER,getenv('COMPUTERNAME'))); 
						% using getenv instead of computerID because we don't want to lower it here
				fLog(ListSettings); % v0.1.023
            end;
        end;
    end
	
	function eLogInit(dirpath)
		if VAR_ErrorLog == -1
			VAR_ErrorLog = 1;
			vLog(C_MSG_ELOGREINIT);
		end;
		if VAR_ErrorLog > 0
			if dirpath(end) ~= '\'
				dirpath = strcat(dirpath,'\');
			end;
			errorLogname = strcat(dirpath,C_ERRLOG_FILENAME_FORMAT);
		end;
	end
	
	function xLogInit(dirpath)
		if VAR_ExtendedLog == -1
			VAR_ExtendedLog = 1;
			vLog(C_MSG_XLOGREINIT);
		end;
		if VAR_ExtendedLog
			if dirpath(end) ~= '\'
				dirpath = strcat(dirpath,'\');
			end;
			xLogname = strcat(dirpath,C_XLOG_FILENAME_FORMAT);
		end;
	end % func xLogInit

	% Log->logfile
	%   if error occurs, disables further logging to file and notifies on screen
    function [OK] = fLog(s)
        OK = 1;
        if VAR_LogToFile > 0
            try
                [lf msg] = fopen(logFilename,'a');
            catch exception
                vLogSuspend(sprintf(C_MSG_FILELOGERROR,logFilename,char(exception.message)));
                VAR_LogToFile = -1;
                OK = 0;
				if VAR_ThrowExceptions,	rethrow(exception); end;
                return;
            end;
            if lf < 0
                vLogSuspend(sprintf(C_MSG_FILELOGERROR,logFilename,msg));
                VAR_LogToFile = -1;
                OK = 0;
                return;
            end;
            try
				fprintf(lf,C_LOGTOFILE_MSG_FORM,fix(clock),s);
                    % ---- DEBUG ----------------------
                    % test went well, turning off debug
					%                     if strfind(s,'skipped')
					%                         ME = MException('EEGbatch:DEBUG_EXCEPTION_FLOG','EEGbatch:DEBUG_EXCEPTION');
					%                         throw(ME);
					%                     end;
                    % ---------------------------------
            catch exception
				fclose(lf); lf = 0;
                vLogSuspend(sprintf(C_MSG_FILELOGERROR,logFilename,char(exception.message)));
                VAR_LogToFile = -1;
                OK = 0;
				if VAR_ThrowExceptions,	rethrow(exception); end;
            end;
			if lf > 0
				fclose(lf);
			end;
        end;
    end

	% Log->screen
	%   appends s to the log window, scrolls there too & selects the
	%   last line. returns position index of s in pos
    function [pos] = vLog(s)
        ss = get(LogControl,'string');

        if numel(ss) == 0
            pos = 1;
            ss{1} = '';
        else
            pos = numel(ss) + 1;
        end

        ss{pos} = s;

        set(LogControl,'string',ss);
        set(LogControl,'listboxtop',numel(ss));
        set(LogControl,'Value',numel(ss));
        drawnow;
    end
	
	function vLogCLC
		set(LogControl,'string',{});
		if ~isempty(DITable) && (DITableSize > 0)
			for i = 1:DITableSize
				DITable(i).logpos = [];
			end;
		end;
	end % func vLogCLC

    function vLogAdd(s)
        % Log->screen status addition to the end-of-line "READY", "ERROR" or something
        %   uses logscreen-cursor to choose which line to extend
        ss = get(LogControl,'string');
        
        if numel(ss) == 0
            ss{1} = '';
        end
        
        pos = get(LogControl,'Value');
        
        if ~isempty(pos) && isnumeric(pos)
		
			if numel(s) == 1
				ss{pos} = [ss{pos} s];
			else
				ss{pos} = [ss{pos} '  ' s];
			end;
            
            set(LogControl,'string',ss);
            drawnow;
        end;
    end
	
	function vLogReplace(s)
		% Log->screen lines that are contantly changing e.g. have a counter in them can be updated with this
		ss = get(LogControl,'string');
		
		if numel(ss) == 0
			ss{1} = '';
		end;
		
		pos = get(LogControl,'Value');
		
		if ~isempty(pos) && isnumeric(pos)
		
			ss{pos} = s;
			
			set(LogControl,'string',ss);
			drawnow;
		end;		
	end
	
	% deletes last line from visual log
	function vLogBackspace
	
		return; % temporarily disabled
		ss = get(LogControl,'string');
		
		if numel(ss) == 0
			ss{1} = '';
		end;
		
		pos = get(LogControl,'Value');
		
		if ~isempty(pos) && isnumeric(pos)
		
			ss(pos) = [];
			
			set(LogControl,'string',ss);
			set(LogControl,'Value',pos-1);
			drawnow;
		end;		
    end

	% Log->screen special treatment for severe errors. s will be is inserted 
    % to the line following logscreen-cursor. Ind indicates which DItable
    % element is affected.
    function vLogErr(ind,s)
        ss = get(LogControl,'string');
        
        if numel(ss) == 0
            ss{1} = '';
        end
        
        pos = get(LogControl,'Value');
        
        if ~isempty(pos) && isnumeric(pos)
            ss = [ss(1:pos)', strcat('    ',s), ss(pos+1:end)']';
            set(LogControl,'string',ss);
            drawnow;
        end;

        for i_erroradd = ind+1:DITableSize
            DITable(i_erroradd).logpos = DITable(i_erroradd).logpos + 1;
        end;
    end

    function vLogSuspend(s)
        % Log->screen, for messages to be appended to the bottom of the list 
        % it scrolls back the log to the saved position afterwards
        lbt = get(LogControl,'ListBoxTop');
        pos = get(LogControl,'Value');
        vLog(s);
        vLogSel(pos);
        set(LogControl,'listboxtop',lbt);
    end

	% sets logscreen-cursor to the given position
    function vLogSel(pos)
        if ~isempty(pos) && isnumeric(pos)
            set(LogControl,'value',pos);
            drawnow;
        end;
    end

	% log to file and to the screen too
    function aLog(s)
        vLog(s);
        fLog(s);
    end

	% same as aLog, but log to the end of the list
    function aLogSuspend(s)
        vLogSuspend(s);
        fLog(s);
    end
	
	% log to the error log and to the screen
	function aeLog(s)
		vLog(s);
		eLog(s);
	end
	
	% Log->errorlog, logfile
    function [OK] = eLog(s) 
		fLog(s);
        OK = 1;
        if VAR_ErrorLog > 0
			mtxname = strcat(errorLogname,'.lock');
			if VAR_ErrorLog_MutexEnabled
				tic;	
				if FSMutexCheck(mtxname)
					vLog(sprintf(C_MSG_ELOG_MTX_WAITING,errorLogname,C_ERRLOG_MUTEX_MAXWAIT));
				end;
				while (toc < C_ERRLOG_MUTEX_MAXWAIT) && FSMutexCheck(mtxname)
					% nope
				end;
				if ~FSMutexCheck(mtxname)
					FSMutexCreate(mtxname); 
				else
					ME = MException('EEGbatch:ERRORLOG:MUTEXERROR',C_MSG_ERRORLOGMUTEXERROR,errorLogname);
					throw(ME);
				end;
			end;			
            try
                [elh msg] = fopen(errorLogname,'a');
            catch exception			
                vLogSuspend(sprintf(C_MSG_ERRORLOGERROR,errorLogname,char(exception.message)));
                VAR_ErrorLog = -1;
                OK = 0;
	            if VAR_ErrorLog_MutexEnabled
					FSMutexDelete(mtxname);
				end;
				if VAR_ThrowExceptions,	rethrow(exception); end;
                return;
            end;
            if elh < 0
                vLogSuspend(sprintf(C_MSG_ERRORLOGERROR,errorLogname,msg));
                VAR_ErrorLog = -1;
                OK = 0;
	            if VAR_ErrorLog_MutexEnabled
					FSMutexDelete(mtxname);
				end;
                return;
            end; 
            try
				fprintf(elh,C_ERRLOG_MSG_FORM,fix(clock),computerID,s);
            catch exception
				fclose(elh);
                vLogSuspend(sprintf(C_MSG_ERRORLOGERROR,errorLogname,char(exception.message)));
                VAR_ErrorLog = -1;
                OK = 0;
	            if VAR_ErrorLog_MutexEnabled
					FSMutexDelete(mtxname);
				end;
				if VAR_ThrowExceptions,	rethrow(exception); end;
				return;
            end;
            fclose(elh);
			if VAR_ErrorLog_MutexEnabled
				FSMutexDelete(mtxname);
			end;
        end;
    end
	
	% debug or troubleshooting log, written into separate file (xLog new version)
    function [OK] = xLog(s) 
        OK = 1;
        if VAR_ExtendedLog > 0
			try
				mtxname = strcat(xLogname,'.lock');
				if VAR_ExtendedLog_MutexEnabled
					tic;	
					if FSMutexCheck(mtxname)
						vLog(sprintf(C_MSG_XLOG_MTX_WAITING,xLogname,C_XLOG_MUTEX_MAXWAIT));
					end;
					while (toc < C_XLOG_MUTEX_MAXWAIT) && FSMutexCheck(mtxname)
						% nope
					end;
					if ~FSMutexCheck(mtxname)
						FSMutexCreate(mtxname); 
					else
						ME = MException('EEGbatch:EXTENDEDLOG:MUTEXERROR',C_MSG_XLOGMUTEXERROR,xLogname);
						throw(ME);
					end;
				end;
				xloginf = dir(xLogname);
				if numel(xloginf) > 0
					if xloginf(1).bytes > C_XLOG_SIZE_LIMIT
						openmode = 'w';
					else
						openmode = 'a';
					end;
				else
					openmode = 'w';
				end; % v0.2.003 % bugfix
				try
					[elh msg] = fopen(xLogname,openmode);
				catch exception			
					vLogSuspend(sprintf(C_MSG_XLOGERROR,xLogname,char(exception.message)));
					VAR_ExtendedLog = -1;
					OK = 0;
					if VAR_ExtendedLog_MutexEnabled
						FSMutexDelete(mtxname);
					end;
					rethrow(exception);
				end;
				if elh < 0
					vLogSuspend(sprintf(C_MSG_XLOGERROR,xLogname,msg));
					VAR_ExtendedLog = -1;
					OK = 0;
					if VAR_ExtendedLog_MutexEnabled
						FSMutexDelete(mtxname);
					end;
					return;
				end; 
				try
					fprintf(elh,C_XLOG_MSG_FORM,fix(clock),computerID,s);
				catch exception
					fclose(elh);
					vLogSuspend(sprintf(C_MSG_XLOGERROR,xLogname,char(exception.message)));
					VAR_ExtendedLog = -1;
					OK = 0;
					if VAR_ExtendedLog_MutexEnabled
						FSMutexDelete(mtxname);
					end;
					rethrow(exception);
				end;
				fclose(elh);
				if VAR_ExtendedLog_MutexEnabled
					FSMutexDelete(mtxname);
				end;
			catch exception
				OK = 0;
				VAR_ExtendedLog = -1;
				fprintf(C_MSG_XLOGEXCEPTION,exception.message);
				if VAR_ThrowExceptions,	rethrow(exception); end;
			end;
		end;
    end % func xLog

%
% ---------- DIRECT HELPER ROUTINES ---------------
%		function [Prj SubjGr Subj Cond Phase] = UnpackFilename(fn)
%		function [YesNo] = MatchFilename(fn,testPrj,testSubjGr,testMask,dirp)
%		function [fn] = PackFilename(pPrj,pSubjGr,pSubj,pCond,pPhase,pEXT)
%		function [setn] = PackSetname(pPrj,pSubjGr,pSubj,pCond)
%		function [unp] = UnpackOPTableLine(unp,ements)
%		function [ements] = PackOPTableLine(unp)
%		function [datasetinfo] = PackDatasetInfo(i,dirpath)
%		function MAKESomeNoise
%		function [ind] = NextOPTable(ind,err)
%		function LoadOPTables(dirpath)

    function [Prj SubjGr Subj Cond Phase] = UnpackFilename(fn)
            % known/handled filename formats
            % SUBJ [SUBJGR]_COND [PRJ]¤PHASE       "A"
            % SUBJ [SUBJGR]_COND [PRJ]             "B"
            % SUBJ_COND [PRJ]¤PHASE                "C"
            % SUBJ_COND [PRJ]                      "D"
            % SUBJ [SUBJGR] [PRJ]¤PHASE            "E"
            % SUBJ [SUBJGR] [PRJ]                  "F"
            % SUBJ [PRJ]¤PHASE                     "G"
            % SUBJ [PRJ]                           "H"
         [~, n e] = fileparts(fn);
         fn = n;
         open_brackets_where = strfind(fn,'[');
         close_brackets_where = strfind(fn,']');
         currency_sign_where = strfind(fn,'¤');
         underscore_where = strfind(fn,'_');
         if numel(open_brackets_where) ~= numel(close_brackets_where)
             % Uneven [ or ] in filename  --> exception
             Prj = ''; SubjGr = ''; Cond = ''; Phase = '';
             Subj = '<ERROR>';
			 if VAR_StrictFileRules
				ME = MException('EEGbatch:InvalidFilename1',C_MSG_INVALIDFILENAME1,strcat(fn,e));
				throw(ME);
			end;
         end;
         if numel(open_brackets_where) == 0         % no []: no subject group, no project name
             Prj = ''; SubjGr = ''; Cond = '';      % -> no data, ignored
             Phase = ''; Subj = '';
         elseif numel(open_brackets_where) == 1     % one []: no subject group, project name in []
             SubjGr = '';
             Prj = fn(open_brackets_where(1)+1:close_brackets_where(1)-1);
             if numel(underscore_where) > 0         % "C"/"D"
                 Subj = fn(1:underscore_where(1)-1);
                 Cond = fn(underscore_where(1)+1:open_brackets_where(1)-1);
             else                                   % "G"/"H"
                 Subj = fn(1:open_brackets_where(1)-1);
                 Cond = '';
             end;
         elseif numel(open_brackets_where) == 2     % 2 pairs of []: [subject group], then [project name]
             SubjGr = fn(open_brackets_where(1)+1:close_brackets_where(1)-1);
             Prj = fn(open_brackets_where(2)+1:close_brackets_where(2)-1);
             if numel(underscore_where) > 0              % "A"/"B"
                 Subj = fn(1:open_brackets_where(1)-1);
                 Cond = fn(underscore_where(1)+1:open_brackets_where(2)-1);
             else                                   % "E"/"F"
                 Subj = fn(1:open_brackets_where(1)-1);
                 Cond = '';
             end;
         else
             Prj = ''; SubjGr = ''; Cond = ''; Phase = '';
             Subj = '<ERROR>';
			 if VAR_StrictFileRules
				ME = MException('EEGbatch:InvalidFilename2',C_MSG_INVALIDFILENAME2,strcat(fn,e));
				throw(ME);
			end;
         end;
         if numel(currency_sign_where) > 0
             Phase = fn(currency_sign_where(1)+1:end);
         else
             Phase = '';
         end;
         Prj = strtrim(Prj);
         SubjGr = strtrim(SubjGr);
         Subj = strtrim(Subj);
         Cond = strtrim(Cond);
         Phase = strtrim(Phase);
    end % func UnpackFilename
 
    function [YesNo] = MatchFilename(fn,testPrj,testSubjGr,testMask,dirp)
        if (numel(testMask) == 3) 
            digits = isstrprop(testMask,'digit');
            if (digits(1) == 1) && (digits(2) == 1) && (digits(3) == 1)
                PhaseMaskOnly = 1;
            else
                PhaseMaskOnly = 0;
            end;
        else
            PhaseMaskOnly = 0;
        end;
        if isempty(testMask) || strcmp(testMask,'')
            % Empty testMask is handled as if it was PhaseMaskOnly. This
            % way it will match those files without phase code. This 
			% approach is better then to let it all files match, since
			% we've already have a form for "all files" which is *.* and 
			% this way we can refer to all files without phase code in
			% OPTables.
            PhaseMaskOnly = 1;
        end;
        if PhaseMaskOnly
            [mfPrj mfSubjGr , mfSubj, ~, mfPhase] = UnpackFilename(fn); % mfSubj re-added % v0.2.003
            [~, ~, e] = fileparts(fn);
            if strcmp(mfSubj,'<ERROR>') %v0.1.006 % v0.2.003 re-enabled see VAR_StrictFileRules
                YesNo = 0;
                return;
            else
				YesNo = ((isempty(testPrj) || strcmpi(testPrj,'') || strcmpi(testPrj,mfPrj)) && ...
						(isempty(testSubjGr) || strcmpi(testSubjGr,'') || strcmpi(testSubjGr,mfSubjGr)) && ...
						(isempty(testMask) || strcmp(testMask,'') || strcmp(testMask,mfPhase)) && ...
						(strcmpi(e,'.SET')));
            end; %v0.1.006
        else % if "WildCardMask"
            mfDL = dir(strcat(dirp,'\',testMask));
            YesNo = 0;
            for iii = 1:numel(mfDL)
                if ~mfDL(iii).isdir && strcmpi(mfDL(iii).name,fn)
                    [mfPrj mfSubjGr , ~, ~, ~] = UnpackFilename(fn);
                    if (isempty(testPrj) || strcmpi(testPrj,'') || strcmpi(testPrj,mfPrj)) && ...
                       (isempty(testSubjGr) || strcmpi(testSubjGr,'') || strcmpi(testSubjGr,mfSubjGr))
                        YesNo = 1;
                        break;
                    end;
                end;
            end;
        end;
    end % func MatchFilename

    function [fn] = PackFilename(pPrj,pSubjGr,pSubj,pCond,pPhase,pEXT)
        
        if strcmp(pSubj,'')
            fn = '<ERROR>';
            ME = MException('EEGbatch:PackFilename_NoSubject',C_MSG_CANNOT_PACK_FN_NO_SUBJECT,pPrj,pSubjGr,pSubj,pCond,pPhase,pEXT);
            throw(ME);
        end;
        
        if strcmp(pSubjGr,'')
            if strcmp(pCond,'')
                fn = sprintf('%s [%s]',pSubj,pPrj);
            else
                fn = sprintf('%s_%s [%s]',pSubj,pCond,pPrj);
            end;
        else
            if strcmp(pCond,'')
                fn = sprintf('%s [%s] [%s]',pSubj,pSubjGr,pPrj);
            else
                fn = sprintf('%s [%s]_%s [%s]',pSubj,pSubjGr,pCond,pPrj);
            end;
        end;
        if ~strcmp(pPhase,'')
            fn = strcat(fn,'¤',pPhase);
        end;
        if ~strcmp(pEXT,'')
            fn = strcat(fn,pEXT);
        end;
    end % func PackFilename

    function [setn] = PackSetname(pPrj,pSubjGr,pSubj,pCond)
        
        if strcmp(pSubj,'')
            setn = '<ERROR>';
            ME = MException('EEGbatch:PackSetname_NoSubject',C_MSG_CANNOT_PACK_SN_NO_SUBJECT,pPrj,pSubjGr,pSubj,pCond,pPhase,pEXT);
            throw(ME);
        end;
        
        if strcmp(pCond,'')
            setn = pSubj;
        else
            setn = strcat(pSubj,'_',pCond);
        end;
        
    end

    function [unp] = UnpackOPTableLine(unp,ements)
		unp.InMask = ements{1};
		unp.Func = ements{3};
		unp.Params = ements{4};

		if strcmp(strtrim(ements{2}),'')
			unp.Conds = {};
		else
			[condgroups] = regexp(ements{2},'\|','split');
			for jj = 1:numel(condgroups)
				unp.Conds{jj} = regexp(condgroups{jj},',','split');
			end;
		end;
		
		if strcmp(strtrim(ements{5}),'')
			unp.OutMask = {};
		else
			unp.OutMask = strtrim(regexp(ements{5},'\|','split'));
		end;
		
		if strncmp(upper(unp.Func),C_FUNCID_USER,5)
			unp.AutoFN = 0;
		else
			unp.AutoFN = 1;
		end;
		
		cm1_where = strfind(upper(unp.Func),C_FUNCID_MULTI1);
		cm2_where = strfind(upper(unp.Func),C_FUNCID_MULTI2);
		if ((numel(cm1_where) > 0) && (cm1_where(1) == 1)) || ...
		   (numel(cm2_where) > 0)
			unp.Multi = 1;
		else
			unp.Multi = 0;
		end;
		
		if numel(ements) > 5
			if strcmpi(strtrim(ements{6}),C_FUNCID_DONTOPEN)
				unp.dontopen = 1;
			else
				unp.dontopen = 0;
			end;
        else
            unp.dontopen = 0;
		end;
    end

    function [ements] = PackOPTableLine(unp)
        
        ements{1} = unp.InMask;

        ements{2} = '';
        for k1 = 1:numel(unp.Conds)
            for k2 = 1:numel(unp.Conds{k1})
                ements{2} = strcat(ements{2},unp.Conds{k1}{k2});
                if k2 < numel(unp.Conds{k1})
                    ements{2} = strcat(ements{2},',');
                end;
            end;
            if k1 < numel(unp.Conds)
                ements{2} = strcat(ements{2},'|');
            end;
        end;

        ements{3} = unp.Func; % = 0
%         for k1 = 1:numel(C_BuiltInFunc)
%             if strcmpi(unp.Func,C_BuiltInFunc{k1})
%                 ements{3} = k1;
%                 break;
%             end;
%         end;
%         if ements{3} == 0
%             ements{3} = 1;
%         end;

        ements{4} = unp.Params;

        ements{5} = '';
        for k1 = 1:numel(unp.OutMask)
            ements{5} = strcat(ements{5},unp.OutMask{k1});
            if k1 < numel(unp.OutMask)
                ements{5} = strcat(ements{5},'|');
            end;
        end;
    end % func PackOPTableLine

    function [datasetinfo] = PackDatasetInfo(i,dirpath)             % param: DITable index
        if DITable(i).Multi > 0
            % generate structure
            datasetinfo(numel(DITable(i).InFile)) = struct('Prj',DITable(i).Prj{1}, ...
                                                           'SubjGr',DITable(i).SubjGr{1}, ...
                                                           'Subj',DITable(i).Subj{1}, ...
                                                           'Cond',DITable(i).Cond{1}, ...
                                                           'FN',strcat(dirpath,DITable(i).InFile{1}));
            % and fill it
            for j = 1:numel(DITable(i).InFile)
                datasetinfo(j).Prj = DITable(i).Prj{j};
                datasetinfo(j).SubjGr = DITable(i).SubjGr{j};
                datasetinfo(j).Subj = DITable(i).Subj{j};
                datasetinfo(j).Cond = DITable(i).Cond{j};
                datasetinfo(j).FN = strcat(dirpath,DITable(i).InFile{j});
            end;
        else
            % only one item
            datasetinfo = struct('Prj',DITable(i).Prj{1}, ...
                               'SubjGr',DITable(i).SubjGr{1}, ...
                               'Subj',DITable(i).Subj{1}, ...
                               'Cond',DITable(i).Cond{1}, ...
                               'FN',strcat(dirpath,DITable(i).InFile{1}));
        end;
    end % func PackDatasetInfo

    function MAKESomeNoise
        sf = 22050;

        s = [];
        for i = 1:numel(C_MAKESOMENOISE_PATTERN)
            n = C_MAKESOMENOISE_PATTERN(i) * sf;
            ss = (1:n) / sf;
            ss = C_MAKESOMENOISE_VOLUME * sin(2*pi * C_MAKESOMENOISE_FREQ(i) * ss);
            s = [s ss];
        end;

        sound(s, sf);        
    end
 
 
    % Conditionally increments and returns "ind". ind would be the index of 
    % next usable OPTable or -1 if there's no such. If err is true, it will
    % thrash and drop current OPtable, all the successors will slide upwards
    % and ind stays the same, otherwise ind++ until it reaches the end.
    function [ind] = NextOPTable(ind,err)
        if err
            if ind == OPTableSize
                OPTableSize = OPTableSize - 1;
                ind = -1;
            else
                for i = OPTableSize:-1:ind+1
                    OPTables(i-1) = OPTables(i);
                    OPTableNames(i-1) = OPTableNames(i);
                end;
                OPTableSize = OPTableSize - 1;
            end;
        else
            if ind == OPTableSize
                ind = -1;
            else
                ind = ind + 1;
            end;
        end;
    end             

	% loads OPTables from given directory
    % --> OPTableNames, OPTables
    function LoadOPTables(dirpath)
        dirlist = dir(strcat(dirpath,'\*',C_OPTABLE_POSTFIX));
        dirlistsiz = numel(dirlist);
        OPTableSize = 0;
        for i = 1:dirlistsiz
            if not(dirlist(i).isdir)
                [~, n e] = fileparts(dirlist(i).name);
                n = strcat(n,e);
                where_is_optable = strfind(lower(n),lower(C_OPTABLE_POSTFIX)); % v0.1.019
                n = n(1:where_is_optable(numel(where_is_optable))-1);
                open_brackets_where = strfind(n,'[');
                OPTableSize = OPTableSize+1;
                OPTableNames(OPTableSize).FileName = strcat(dirpath,dirlist(i).name);
                if numel(open_brackets_where) == 0
                    % no [] --> whole filename represents project name								% "a" Prj..._optable.txt
                    OPTableNames(OPTableSize).Prj = n;
                    OPTableNames(OPTableSize).SubjGr = '';
                else
                    % okay, we've got project name. do we have subject group info?
                    close_brackets_where = strfind(n(open_brackets_where(1)+1:end),']');
                    if numel(close_brackets_where) == 0
                        % uneven  [...], project name: till the end									% "b" [Prj..._optable.txt
                        OPTableNames(OPTableSize).Prj = n(open_brackets_where(1)+1:end);
                    else
                        % got [...] --> [project name]
                        % 
                        OPTableNames(OPTableSize).Prj = n(open_brackets_where(1)+1:open_brackets_where(1)+1-1+close_brackets_where(1)-1);
                        if numel(open_brackets_where) > 1
                            % got project name & subject group info, too
                            hol_van_zaro__ = strfind(n(open_brackets_where(2)+1:end),']');
                            if numel(hol_van_zaro__) == 0
                                % uneven second [...], subject group: till the end
                                OPTableNames(OPTableSize).SubjGr = n(open_brackets_where(2)+1:end);	% "c" [Prj][SubjGr..._optable.txt   
                            else
                                % two []s: [project name] [subject group]							% "d" [Prj][SubjGr]_optable.txt
                                OPTableNames(OPTableSize).SubjGr = n(open_brackets_where(2)+1:open_brackets_where(2)+1-1+hol_van_zaro__(1)-1);
                            end; % if second "]"
                        else
                            OPTableNames(OPTableSize).SubjGr = '';
                        end; % if second "["
                    end; % if first "]"
                end; % if first "["
            end; % if not directory
        end; % for dirlist
		
        if OPTableSize > C_OPTABLES_NR_DEFAULT
            % allocate OPTables to have at least C_OPTableSizeDefault elements
            OPTables(OPTableSize) = OPTables(1);
        end;
            
        if OPTableSize > 0
            i = 1;
        else
            i = -1;
        end;
		
		OPTableAllLines = 0; % v0.2.003
        
        while (i ~= -1) % i: variable holding optable nr
            [ofh,msg] = fopen(OPTableNames(i).FileName);
            if ofh == -1
                aLogSuspend(sprintf(C_MSG_OPTABLEIOERR,OPTableNames(i).FileName,msg));
                i = NextOPTable(i,1);
                continue;
            end;
            
            try
                s = '';
                while ischar(s) && ~strcmp(strtrim(s),strtrim(C_OPTABLE_BEGIN))
                    s = fgets(ofh);
                end;
                s = '';
                j = 1;
                while ischar(s) && ~strcmp(strtrim(s),strtrim(C_OPTABLE_END))
                    s = fgetl(ofh); % changed from fgets % v0.2.001
                    if strcmp(strtrim(s),strtrim(C_OPTABLE_END))
                        break;
                    end;

					% v0.1.017 - remove remarks and convert all %% to %
					% (% v0.2.001 - working)
					
                    commentmarks = strfind(s,'%');
					i_com = 1;
					while i_com <= numel(commentmarks)
						if i_com < numel(commentmarks)
							if (commentmarks(i_com+1) == commentmarks(i_com)+1)
								i_com = i_com + 2;
							else
								s = s(1:commentmarks(i_com)-1);
								break;
							end;
						else
							s = s(1:commentmarks(i_com)-1);
							break;
						end;
					end; % while
					
					s = strrep(s,'%%','%');
					
					if ~strcmp(strtrim(s),'') % v0.1.017 -- skip empty lines 

    					[ements] = regexp(s,'\t','split'); % changed from (\t|\n) % v0.2.001
				
                        if numel(ements) < 5 
                            ME = MException('EEGbatch:OPTABLE_STRUCT_ERR',C_MSG_OPTABLEERR);
                            throw(ME);
                        end;

                        [OPTables(i,j)] = UnpackOPTableLine(OPTables(i,j),ements);
                        
                        j = j + 1;
                    
                    end;

                end; % while not feof
            catch exception
                fclose(ofh); ofh = 0;
                aLogSuspend(sprintf(C_MSG_OPTABLEIOERR,OPTableNames(i).FileName,char(exception.message)));
                i = NextOPTable(i,1);
				if VAR_ThrowExceptions,	rethrow(exception); end;
                continue;
            end;
			
			if ofh > 0
				fclose(ofh);
			end;
            
            OPTables(i,j).InMask = '';
            OPTables(i,j).Func = ''; % end mark to OPTables(i,:)
            
            i = NextOPTable(i,0);
        end; % for i

		OPTableAllLines = 0; % v0.2.003
		for i = 1:OPTableSize
			for j = 1:numel(OPTables(i,:))
				if strcmpi(OPTables(i,j).Func,'')
					break;
				else
					OPTableAllLines = OPTableAllLines + 1;
				end;
			end; % for j
		end; % for i
    end % function LoadOPTables
%
%
%
% -------------- MAIN ROUTINES --------------------
%		function SearchDatasets(ByFiles,FindIn)
%		function DITable_Finalize(dirpath)
%		function ProcessDITable(usertoo,dirpath)

	function SearchDatasets(ByFiles,FindIn)
	% SearchDatasets new version % v0.2
		if (isempty(FindIn)) || ...
			(iscell(FindIn) && numel(FindIn) == 0) || ...
			(ischar(FindIn) && strcmp(FindIn,''))
			return;
		end;
		
		try % ------------------------------------------
		
			% prepare dirpath/dirlist
			
			if ByFiles == SDS_BYFILES
				% SDS_BYFILES: FindIn is a list of files to deal with
				% dirpath will be the path of the first item in the list
				% we create our own dirlist structure from the list
				[dirpath, ~, ~] = fileparts(FindIn{1});
				if dirpath(end) ~= '\'
					dirpath = strcat(dirpath,'\');
				end;
				dirlist(numel(FindIn)) = struct('name','','isdir',0,'flag',0);
				for i = 1:numel(FindIn)
					[d, n, e] = fileparts(FindIn{i});
					if d(end) ~= '\'
						d = strcat(d,'\');
					end;
					if ~strcmpi(dirpath,d)
						ME = MException('EEGbatch:SearchDatasets_MultipleDir',C_MSG_SEARCHDATASETSMULTIDIR,dirpath,d);
						throw(ME);
					end;
					dirlist(i).name = strcat(n,e);
					dirlist(i).isdir = 0;
					dirlist(i).flag = 0;
				end;
			else
				% SDS_BYDIR: FindIn is a directory with full path
				% dirpath will be that
				% we create dirlist via dir(dirpath)
				dirpath = FindIn;
				if dirpath(end) ~= '\'
					dirpath = strcat(dirpath,'\');
				end;
				dirlist = dir(strcat(dirpath,'*.*'));
				for i = numel(dirlist):-1:1
					dirlist(i).flag = 0;
				end;
			end;
			
			% some initializations
			
            glob_findin = dirpath;				% set up global findin

            fLogInit(glob_findin);				% initialize logs
			eLogInit(glob_findin);
			xLogInit(glob_findin);

            if VAR_OptRatio_Override > -1		% initialize perfomance index (PI)
                opt_ratio_perf = VAR_OptRatio_Override;
				myPI = -1;
                vLog(sprintf(C_MSG_PI_OVR,opt_ratio_perf));
            else
                [opt_ratio_perf myPI mainPERFtable] = EEGbatch_perfindex(glob_findin,VAR_PerfInd_HideMe,VAR_PerfInd_NoRecalc);
                set(LbOptPercent,'string',num2str(round(opt_ratio_perf)));
                set(OptSlider,'Value',round(opt_ratio_perf));
            end;

            PathMan(glob_findin);				% path manager: add findin to path
												% this makes .m files visible in findin directory
												
			% Load OP tables

            LoadOPTables(glob_findin);
            aLog(sprintf(C_MSG_OPTABLES_LOADED,OPTableSize));
			
			% some more initializations

            DITableSize = 0; 
			StatusCounter = 0; % v0.2.003
			
			if (numel(dirlist) > 500)  % **AA393xC**
				vLog(''); % empty string because it will be replaced by the directory reading status
			end;
			
			% MAIN FILLING LOOP
			% nest level		loop dealing with		variable
			% 1					one OPtable				i
			% 2					one line in OPTable		j
			%		pass 1
			% 3					one cond group in line	c1
			% 4					one cond in cond group	c2
			% 5					one dirlist entry		k
			%		pass 2
			% 3					one dirlist entry		k
			
			for i = 1:OPTableSize
				for j = 1:size(OPTables,2)
                    if isempty(OPTables(i,j).Func) || strcmp(OPTables(i,j).Func,'')
                        break;
                    end;
					% for i,j starts here
					
					% some .flag clearing
					
					for k = 1:numel(dirlist)
						dirlist(k).flag = 0;
					end;
					
					% pass 1 - condition groups

					StatusCounter = StatusCounter + 1;
					
					for c1 = 1:numel(OPTables(i,j).Conds) 
						% for all condition groups
						% we create a new item
						
						% prepare the new item
						DITableSize = DITableSize + 1;
						if DITableSize > numel(DITable)
							xLog(sprintf(C_MSG_INCREASINGDITABLE,numel(DITable),numel(DITable)+C_DITABLES_LINENR_DEFAULT));
							DITable(numel(DITable)+C_DITABLES_LINENR_DEFAULT) = DITable(1);
						end;
						
						DITable(DITableSize).Status = DIS_READY;		% prepare the entry, resetting all fields
						DITable(DITableSize).InFile = {};
						DITable(DITableSize).Prj = {};
						DITable(DITableSize).SubjGr = {};
						DITable(DITableSize).Subj = {};
						DITable(DITableSize).Cond = {};
                        DITable(DITableSize).Func = OPTables(i,j).Func;	
                        DITable(DITableSize).Multi = OPTables(i,j).Multi;
                        DITable(DITableSize).AutoFN = OPTables(i,j).AutoFN;
						DITable(DITableSize).dontopen = OPTables(i,j).dontopen;
                        DITable(DITableSize).Params = OPTables(i,j).Params;
						DITable(DITableSize).OutFile = {};
						DITable(DITableSize).logpos = [];
						DITable(DITableSize).mtxid = {};
						
						% condition hunting
						
                        Conds_found = 0; % in the new version, this replaces DITableEntryOK

                        for c2 = 1:numel(OPTables(i,j).Conds{c1})
							
                            for k = 1:numel(dirlist)
								if (numel(dirlist) > 500) && (mod(k,10) == 0) % **AA393xC** % finalized: % v0.2.003
									vLogReplace(sprintf(C_MSG_SEARCHING,StatusCounter,k,2*OPTableAllLines,numel(dirlist)));
								end;
                                if dirlist(k).isdir
                                    continue;
                                end;
                                if ~MatchFilename(dirlist(k).name,OPTableNames(i).Prj,OPTableNames(i).SubjGr,OPTables(i,j).InMask,dirpath)
									% comparing Prj, SubjGr, InMask/mPhase
                                    continue;
                                end;
                                
                                [mPrj mSubjGr mSubj mCond mPhase] = UnpackFilename(dirlist(k).name);
                                
                                if strcmpi(mCond,OPTables(i,j).Conds{c1}{c2})
									% comparing Cond
                                    Conds_found = Conds_found + 1;
                                    DITable(DITableSize).InFile{Conds_found} = dirlist(k).name;
                                    DITable(DITableSize).Prj{Conds_found} = mPrj;
                                    DITable(DITableSize).SubjGr{Conds_found} = mSubjGr;
                                    DITable(DITableSize).Subj{Conds_found} = mSubj;
                                    DITable(DITableSize).Cond{Conds_found} = mCond;
                                    dirlist(k).flag = 1;
                                end; % if Cond matches
                            end; % for k 1:numel(dirlist)
                        end; % for c2 1:numel(OPTables(i,j).Conds{c1}
						
						% Conds_found + OUTFILE
						% check if condition hunting was successful (all conditions found in condition group)
						% if it was, check if not all output-files are exist
						
                        if Conds_found < numel(OPTables(i,j).Conds{c1})
							% not all condition-mates found, invalidate DITable entry
                            DITableSize = DITableSize - 1;
                        else
							% all condition-mates found, DITable entry is valid
							% as far as not all output-files are exists (work's already done)
							
							% OUTFILE
							% - fill out .OutFile fields
							% - check if they exist, if so, mark the entry as "already done"
							% (if OutMask is empty, nothing to do here,
							% we leave the job to DITable_Finalize)
                            if numel(OPTables(i,j).OutMask) == 0
								% if OutMask is empty, leave it to DITable_Finalize
                                all_outfile_exists = 0;
                            else
                                all_outfile_exists = 1;
                                for outmask_i = 1:numel(DITable(DITableSize).InFile)
									% for all InFile
                                    for outmask_j = 1:numel(OPTables(i,j).OutMask)
										% for all OutMask
										[mPrj mSubjGr mSubj mCond mPhase] = UnpackFilename(DITable(DITableSize).InFile{outmask_i});
                                        DITable(DITableSize).OutFile{outmask_i,outmask_j} = PackFilename(mPrj,mSubjGr,mSubj,mCond,OPTables(i,j).OutMask{outmask_j},'.SET');
                                        if ~exist(strcat(dirpath,DITable(DITableSize).OutFile{outmask_i,outmask_j}),'file')
                                            all_outfile_exists = 0;
                                        end;
                                    end;
                                end;
                            end; % if OutMask isn't empty
                            if all_outfile_exists
                                DITable(DITableSize).Status = DIS_ALREADYDONE;
                            end;
                            
                        end; % if all Conds found
						
                    end; % for c1
					
					% pass 2 - conditions which not belong to cond.group

					StatusCounter = StatusCounter + 1;

                    for k = 1:numel(dirlist)
						% for all matching dirlist entries
						% we create a new item in DITable
						if (numel(dirlist) > 500) && (mod(k,10) == 0) % **AA393xC** % finalized: % v0.2.003
							vLogReplace(sprintf(C_MSG_SEARCHING,StatusCounter,k,2*OPTableAllLines,numel(dirlist)));
						end;
                        if (dirlist(k).isdir == 1) || (dirlist(k).flag == 1)
							% if it's a directoy or flagged in pass 1, ignore it here
                            continue;
                        end;
						if ~MatchFilename(dirlist(k).name,OPTableNames(i).Prj,OPTableNames(i).SubjGr,OPTables(i,j).InMask,dirpath)
							% comparing Prj, SubjGr, InMask/mPhase
							continue;
						end;
						[mPrj mSubjGr mSubj mCond mPhase] = UnpackFilename(dirlist(k).name);
						
						% prepare and fill out the new item
						
						DITableSize = DITableSize + 1;
						if DITableSize > numel(DITable)
							DITable(numel(DITable)+C_DITABLES_LINENR_DEFAULT) = DITable(1);
							xLog(sprintf(C_MSG_INCREASINGDITABLE,numel(DITable),numel(DITable)+C_DITABLES_LINENR_DEFAULT));
						end;
						
						DITable(DITableSize).Status = DIS_READY;		% prepare the entry, resetting all fields
                        DITable(DITableSize).InFile{1} = dirlist(k).name;
                        DITable(DITableSize).Prj{1} = mPrj;  
                        DITable(DITableSize).SubjGr{1} = mSubjGr;
                        DITable(DITableSize).Subj{1} = mSubj;
                        DITable(DITableSize).Cond{1} = mCond;
                        DITable(DITableSize).Func = OPTables(i,j).Func;	
                        DITable(DITableSize).Multi = OPTables(i,j).Multi;
                        DITable(DITableSize).AutoFN = OPTables(i,j).AutoFN;
						DITable(DITableSize).dontopen = OPTables(i,j).dontopen;
                        DITable(DITableSize).Params = OPTables(i,j).Params;
						DITable(DITableSize).OutFile = {};
						DITable(DITableSize).logpos = [];
						DITable(DITableSize).mtxid = {};
												

						% (Conds_found +) OUTFILE
						% check if not all output-files are exist
						
						% OUTFILE
						% - fill out .OutFile fields
						% - check if they exist, if so, mark the entry as "already done"
						% (if OutMask is empty, nothing to do here,
						% we leave the job to DITable_Finalize)
						if numel(OPTables(i,j).OutMask) == 0
							% if OutMask is empty, leave it to DITable_Finalize
							all_outfile_exists = 0;
						else
							all_outfile_exists = 1;
							for outmask_i = 1:numel(DITable(DITableSize).InFile)
								% for all InFile
								for outmask_j = 1:numel(OPTables(i,j).OutMask)
									% for all OutMask
									[mPrj mSubjGr mSubj mCond mPhase] = UnpackFilename(DITable(DITableSize).InFile{outmask_i}); % v0.2.002 char( removed
									DITable(DITableSize).OutFile{outmask_i,outmask_j} = PackFilename(mPrj,mSubjGr,mSubj,mCond,OPTables(i,j).OutMask{outmask_j},'.SET');
									if ~exist(strcat(dirpath,DITable(DITableSize).OutFile{outmask_i,outmask_j}),'file')
										all_outfile_exists = 0;
									end;
								end;
							end;
						end; % if OutMask isn't empty
						if all_outfile_exists
							DITable(DITableSize).Status = DIS_ALREADYDONE;
						end;
						
                    end; % for k

                end; % for j
            end; % for i (1:OPTableSize)

            DITable_Finalize(glob_findin);

        catch exception % ------------------------------------------------

            switch exception.identifier
                case { 'EEGbatch:InvalidFilename1','EEGbatch:InvalidFilename2','EEGbatch:SearchDatasets_MultipleDir' }
                    aeLog(sprintf(C_MSG_ERRORSD,exception.message));
                otherwise
                    aeLog(sprintf(C_MSG_INTERRORSD,exception.message));
            end;
			
			if VAR_DetailedExceptions % v0.2.003
				stringtoreport = Exception2Report(exception);
				fprintf('%s',stringtoreport);
				if VAR_ErrorLog
					eLog(stringtoreport);
				elseif VAR_LogToFile
					fLog(stringtoreport);
				end;
			end;
			if VAR_ThrowExceptions,	rethrow(exception); end;
			DITableSize = 0; % v0.2.003 - error occurred, DITable invalid
        end; % try-catch

		if (numel(dirlist) > 500)  % **AA393xC**
%			vLogBackspace;
		end;

	end % func SearchDatasets

	% its job is to do some finalizing checks on DITable
	% - does the plugin .Func field referencing exist
	% - if any line in DITable wants to pass multiple datasets to a plugin which can't deal with it
	% - setting the ALREADY_DONE flag to those plugins which checks themselves if they already run
	% for internal use - SearchDatasets calls it every time it's needed
    function DITable_Finalize(dirpath)
	
        function [YesNo] = CheckForPlugins
            DITableOK = zeros(1,DITableSize);
            for i = 1:DITableSize
                if DITable(i).Status < 0
                    continue;
                end;
                for j = 1:numel(C_BuiltInFunc)
                    DITable(i).Func;
                    if strcmp(DITable(i).Func,C_BuiltInFunc(j))
                        DITableOK(i) = 1;
                        break;
                    end;
                end;
                if DITableOK(i) == 0
                    if exist(DITable(i).Func)
                        DITableOK(i) = 1;
                    end;
                end;
            end;
            YesNo = 1;
            for i = 1:numel(DITableOK)
                if DITableOK(i) == 0
                    DITable(i).Status = DIS_NOPLUGIN;
                    eLog(sprintf(C_MSG_NOPLUGIN_ERROR,DITable(i).Func));
                    YesNo = 0;
                end;
            end;
        end % func CheckForPlugins
        
        function [YesNo] = CheckForMulti
            DITableOK = ones(1,DITableSize);
            for i = 1:DITableSize
                if DITable(i).Status < 0
                    continue;
                end;
                if (DITable(i).Multi == 0) && (numel(DITable(i).InFile) > 1)
                    DITableOK(i) = 0;
                end;
            end;
            YesNo = 1;
            for i = 1:numel(DITableOK)
                if DITableOK(i) == 0
                    DITable(i).Status = DIS_MULTIERROR;
                    eLog(sprintf(C_MSG_MULTI_ERROR,DITable(i).Func));
                    YesNo = 0;
                end;
            end;
        end
                
        function CheckForAlreadyDone(dirpath)
            for i = 1:DITableSize
                if DITable(i).Status < 0 % ERRORs < 0; WARNINGs > 0
                    continue;
                end;
                if numel(DITable(i).OutFile) > 0 % if OutFile names are specified, then the check has been run already, see SearchDataSets OUTFILE stage
                    continue;
                end;
                datasetinfo = PackDatasetInfo(i,dirpath);
                funcres = -1; ALLEEG = 0;         % to avoid MATLAB:err_static_workspace_violation calling 'eval()'

                if strcmpi(DITable(i).Params,'')
                    streval = strcat('[funcres, ALLEEG] = ',DITable(i).Func,'(datasetinfo,0,''check'');');
                else
                    streval = strcat('[funcres, ALLEEG] = ',DITable(i).Func,'(datasetinfo,0,''check'',',DITable(i).Params,');');
                end;
                try
%                    fprintf(strcat('DEBUG:::',streval,'\n')); 
%                    funcres = 10;
                   eval(streval);       
                catch exception
                    aeLog(sprintf(C_MSG_ERRORCHK,DITable(i).Func,exception.message));
                    DITable(i).Status = DIS_ERRORCHK;
					if VAR_ThrowExceptions,	rethrow(exception); end;
                end;
                if (funcres == 0) && (DITable(i).Status ~= DIS_ERRORCHK)
                    DITable(i).Status = DIS_ALREADYDONE; % 0
                end;
            end;
        end
        
        if not(CheckForPlugins)
            aeLog(C_MSG_NOPLUGIN_WARNING);
        end;
        
        if not(CheckForMulti)
           aeLog(C_MSG_MULTI_WARNING);
        end;
        
        CheckForAlreadyDone(dirpath);  
    
    end % func DITable_Finalize

    function ProcessDITable(usertoo,dirpath)
    % ProcessDITable alias Master of Ceremony
    % executes direct commands in DITable line by line
    % column 1: filename
    %     if ".SET", it's opened, too, if not, its name just passed to the refered procedure
    % columns 2-5: Prj,SubjGr,Subj,Cond
    %     these will be given to the procedure as arguments
	%     (it will be given no phase info, because that's ProcessDITable competency
    % column 6: procedure name (plugin or built-in)
    % column 7: Multi[ple datasets allowed]
	%     indicates that the procedure can handle multiple datasets at once. If we 
	%     had to give multiple datasets to a procedure with Multi set to 0
	%     ProcessDITable separates those and gives the datasets one by one to the
	%     procedure
    % column 8: AutoFN [unattended]
	%     indicates that the procedure is designed to run unattended, without
	%     need of human interaction. Auto mode runs procedures like these only.
    % column 9: Additional params
	%     here you can specify additional fixed parameters to the procedure,
	%     they will be appended to the end of argument list
    % column 10: OutFile(s)
	%     when the procedure has done its job, ProcessDITable will save the 
	%     dataset with this filename (or all of these -- opportunity to split
	%     the execution chain). If empty, it means procedure has a special way
	%     to output its results and ProcessDITable doesn't have to take care 
	%     of it.
    % --
	%     ProcessDITable will log into the dataset the fact that it's called 
	%     procedure on it
	
		fLogCondense(dirpath); % v0.1.017
		ResetMutex(dirpath); % v0.1.018
    
        try % -mutexMINUS-------------------------------------------------
    
			vLog(C_MSG_MUTEXHOLD);
            mutexHOLD(dirpath,usertoo,(usertoo == PDI_USERMODE) || (usertoo == PDI_USERONLY)); % v0.2.002
			vLogSel(get(LogControl,'Value')-1);
			vLogBackspace;

            try % -mutexPLUS--------------------------------------------------

                UserModeNotice = 0; AutoModeNotice = 0;
				
				% vLogAdd pre-run
				
				for i = 1:DITableSize
					if ~isempty(DITable(i).logpos)      
						vLogSel(DITable(i).logpos);
					end;
					if (usertoo==PDI_AUTOMODE) && (DITable(i).AutoFN == 0)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_USERMODE_SKIPPED);
							UserModeNotice = 1;
						end;
						continue;
					end;
					if (usertoo==PDI_USERONLY) && (DITable(i).AutoFN == 1)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_AUTOMODE_SKIPPED);
							AutoModeNotice = 1;
						end;
						continue;
					end;
					
					if (DITable(i).Status == DIS_OPTMANAGEMENT)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_OPTMANAGEMENT);
						end;
					elseif (DITable(i).Status == DIS_DONE)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_DONE);
						end;
					elseif (DITable(i).Status == DIS_NOPLUGIN)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_NOPLUGIN);
						end;
					elseif (DITable(i).Status == DIS_ERRORCHK)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_ERRORCHK);
						end;
					elseif (DITable(i).Status == DIS_ERRORRUN)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_ERRORRUN);
						end;
					elseif (DITable(i).Status == DIS_MULTIERROR)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_MULTIERROR);
						end;
					elseif (DITable(i).Status == DIS_MUTEXERROR)
						if ~isempty(DITable(i).logpos)
							vLogAdd(C_MSG_THIS_MUTEXERROR);
						end;
					elseif not(DITable(i).Status == DIS_READY)
						if ~isempty(DITable(i).logpos)
							vLogAdd(sprintf(C_MSG_THIS_EXOTIC,DITable(i).Status)); 
						end;
					end;
				end; % for i	
				
				% main pass
				DIthingsdone = 0;
				ETAreset;
                for i = 1:DITableSize

                    managetimers;
					ETAupdate;
					
                    if opStatus ~= OPS_TERMINATING
					
						% set position of visual log

                        if ~isempty(DITable(i).logpos)      % **A191xC**
                            vLogSel(DITable(i).logpos);
                        end;
						if not(DITable(i).Status == DIS_READY)
							continue;
						end;
						if (usertoo==PDI_AUTOMODE) && (DITable(i).AutoFN == 0) % v0.2.002
							continue;
						end;
						if (usertoo==PDI_USERONLY) && (DITable(i).AutoFN == 1)
							continue;
						end;
						
                        % create datasetinfo

                        datasetinfo = PackDatasetInfo(i,dirpath);

                        % clear study
                        ALLEEG = []; EEG = []; CURRENTSET = [];

                        % create ALLEEG, open datasets
						
						all_samples = 0;
						all_epochs = 0;
						plugin_prof = true;
						plugin_calc = false;
						save_prof = true;
						load_prof = true;
						
						if ~DITable(i).dontopen

							load_starts = clock;
							for j = 1:numel(DITable(i).InFile)
								[d n e] = fileparts(DITable(i).InFile{j});
								if strcmpi(e,'.SET')                                           % if .SET, we can open it
									try
										EEG = pop_loadset('filename',strcat(n,e),'filepath',dirpath);
									catch exception
										exception.identifier = 'EEGbatch:ERROR_LOADING';
										rethrow(exception);
									end;
									[ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG,EEG); 
									% that's why "global EEG" works in USER_DROPCOMP
									% and needed for using ALLEEG structure, too
									
									if numel(size(EEG.data)) > 2
										all_samples = all_samples + size(EEG.data,2)*size(EEG.data,3);
										if all_epochs ~= -1
											all_epochs = all_epochs + size(EEG.data,3);
										end;
									else
										all_samples = all_samples + size(EEG.data,2);
										all_epochs = -1;
									end;
									% collect some statistics data for plugin_start, plugin_end
								else
									load_prof = false;
								end;
							end;
							load_ends = clock;
						else
							load_prof = false;
						end; % v0.2.001

                        % datasetinfo OK, ALLEEG OK, format the eval-string
						if strcmpi(DITable(i).Params,'')
							streval = strcat('[funcres, ALLEEG, logstr] = ',DITable(i).Func,'(datasetinfo,ALLEEG,''run'');');
						else
							streval = strcat('[funcres, ALLEEG, logstr] = ',DITable(i).Func,'(datasetinfo,ALLEEG,''run'',',DITable(i).Params,');');
						end;

                        DITable(i).Status = DIS_DONE;
                        excmsg = '';
                        funcres = 0; logstr = ''; % see check

						plugin_starts = clock;
                        try
							eval(streval);
                        catch exception
							plugin_prof = false;
                            DITable(i).Status = DIS_ERRORRUN;
                            excmsg = exception.message;
							if VAR_ThrowExceptions,	rethrow(exception); end;
                        end;
						plugin_ends = clock;

                        % processing funcres: >= 0: info, < 0: error

                        if DITable(i).Status ~= DIS_ERRORRUN
                            DITable(i).Status = DIS_EXTERNALFACTOR * funcres;
                        end;

                        if strcmpi(excmsg,'') && (funcres < 0)
                            excmsg = sprintf(C_MSG_EXCEPTION_ONLY_CODE,funcres);
                        end;

                        % logging
                        
                        if numel(ALLEEG) > 1
                            condslist = '';
                            inflist = '';
                            for j = 1:numel(ALLEEG)
                                inflist = strcat(inflist,DITable(i).InFile{j},', ');
                                condslist = strcat(condslist,DITable(i).Cond{j});
                            end;
                            inflist = inflist(1:end-2);
                        else
                            inflist = DITable(i).InFile{1};
                        end;

                        for j = 1:numel(ALLEEG)
                            outf = '';
                            % **311B**
                            if ~isempty(DITable(i).OutFile)
                                for k = 1:numel(DITable(i).OutFile(j,:))
                                    outf = strcat(outf,DITable(i).OutFile{j,k},', ');
                                end;
                                outf = outf(1:end-1);
                            end;
							if VAR_LogMemState % v0.1.016
								[sv uv] = memory; 
								ll1 = sprintf(C_MSG_DSETLOGLINE1MEM, ...
									floor(sv.MemUsedMATLAB/1024/1024),floor(sv.MaxPossibleArrayBytes/1024/1024), ...
									floor(uv.PhysicalMemory.Available/1024/1024),numel(fopen('all')));
							else
								ll1 = sprintf(C_MSG_DSETLOGLINE1NOMEM); % v0.1.019
							end;
							if VAR_LogPluginBenchmark
								if plugin_prof
									plugin_calc = true;
									plugin_ends = plugin_ends - plugin_starts;
									if (plugin_ends(1) ~= 0) || (plugin_ends(2) ~= 0)
										ll1b = C_MSG_DSETLOGLINE1B_UNMEASURABLE;
									else
										plugin_ends_sec = plugin_ends(3:6)*[86400 3600 60 1]';
										if plugin_ends_sec == 0
											ll1b = C_MSG_DSETLOGLINE1B_UNMEASURABLE;
										else
											if all_epochs ~= -1
												epochs_speed = all_epochs / plugin_ends_sec;
											else
												epochs_speed = -1;
											end;
											plugin_speed = all_samples / plugin_ends_sec;
											ll1b = sprintf(C_MSG_DSETLOGLINE1B, ...
												floor(plugin_ends_sec/60),mod(plugin_ends_sec,60), ...
												epochs_speed,plugin_speed);
										end;
									end;
								end;
							end;
                            ll2 = sprintf(C_MSG_DSETLOGLINE2,inflist,DITable(i).Func,outf);
                            ll4 = C_MSG_DSETLOGLINE4;
                            if (DITable(i).Status == DIS_ERRORRUN) || (DITable(i).Status < 0)
                                ll3 = sprintf(C_MSG_DSETLOGLINE3E,DITable(i).Params,excmsg);
                            elseif numel(ALLEEG) > 1
                                ll3 = sprintf(C_MSG_DSETLOGLINE3M,DITable(i).Params,condslist);
                            else
                                ll3 = sprintf(C_MSG_DSETLOGLINE3S,DITable(i).Params);
                            end;
							if (DITable(i).Status == DIS_ERRORRUN) || (DITable(i).Status < 0)
								ALLEEG(j) = dLog(ALLEEG(j),ll1); eLog(ll1);
								if VAR_LogPluginBenchmark
									ALLEEG(j) = dLog(ALLEEG(j),ll1b); eLog(ll1b);
								end;
								ALLEEG(j) = dLog(ALLEEG(j),ll2); eLog(ll2);
								ALLEEG(j) = dLog(ALLEEG(j),ll3); eLog(ll3);
								logstr = strtrim(logstr); 
								if ~strcmpi(logstr,'') 
									ALLEEG(j) = dLog(ALLEEG(j),logstr); eLog(logstr);
								end;
								ALLEEG(j) = dLog(ALLEEG(j),ll4); eLog(ll4);
							else
								ALLEEG(j) = dLog(ALLEEG(j),ll1); fLog(ll1);
								if VAR_LogPluginBenchmark
									ALLEEG(j) = dLog(ALLEEG(j),ll1b); fLog(ll1b);
								end;
								ALLEEG(j) = dLog(ALLEEG(j),ll2); fLog(ll2);
								ALLEEG(j) = dLog(ALLEEG(j),ll3); fLog(ll3);
								logstr = strtrim(logstr); % v0.1.016
								if ~strcmpi(logstr,'') % v0.1.016 ide
									% fLog calls stripped out of plugins, this is the substitute here % **111A**
									ALLEEG(j) = dLog(ALLEEG(j),logstr); fLog(logstr);
								end;
								ALLEEG(j) = dLog(ALLEEG(j),ll4); fLog(ll4);
							end;
                        end;

                        % save dataset(s), if was no error

                        if (DITable(i).Status ~= DIS_ERRORRUN) && (DITable(i).Status >= 0) && ...
                                ~isempty(DITable(i).OutFile) % **311C**

							save_starts = clock;
                            for j = 1:numel(ALLEEG)
                                for k = 1:numel(DITable(i).OutFile(j,:))
                                    [~, n e] = fileparts(DITable(i).OutFile{j,k});
									try
										pop_saveset(ALLEEG(j), 'filename', strcat(n,e), 'filepath', dirpath);
									catch exception
										exception.identifier = 'EEGbatch:ERROR_SAVING';
										rethrow(exception);
									end;
                                end;
                            end;
							save_ends = clock;
						else
							save_prof = false;
                        end;
                        
                        % clear study
                        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

                        if (DITable(i).Status == DIS_ERRORRUN) || (DITable(i).Status < 0)
                            vLogErr(i,excmsg); % **ALE33**
                        else
							if ~isempty(DITable(i).logpos)      
								vLogSel(DITable(i).logpos);
							end;
                            vLogAdd(sprintf(C_MSG_VLOGADD,DITable(i).Status,fix(clock)));
                        end;

                        % DITable(i).logpos = []; 

                    end;

                    if opStatus == OPS_TERMINATING
						if VAR_DEBUG
							fprintf('CANCEL PRESSED. vLog changes:\n'); % DEBUG:::
							fprintf('%s\t%s\t%s\t%s\t%s\n','i','DITable(i).logpos','LogControl.Value','inFile','Func');
							xLog('CANCEL PRESSED. vLog changes:\n'); % DEBUG:::
							xLog(sprintf('%s\t%s\t%s\t%s\t%s\n','i','DITable(i).logpos','LogControl.Value','inFile','Func'));
						end;
							
                        if i ~= DITableSize
                            for i_cancelled = i+1:DITableSize
								if ~isempty(DITable(i_cancelled).logpos) % v0.2.002 bug fixed: i->i_cancelled
									vLogSel(DITable(i_cancelled).logpos);
									if VAR_DEBUG
										fprintf('%u\t%u\t%u\t%s\t%s\n', ... % DEBUG:::
											i_cancelled,DITable(i_cancelled).logpos,get(LogControl,'value'), ...
											DITable(i_cancelled).InFile{1},DITable(i_cancelled).Func);
										xLog(sprintf('%u\t%u\t%u\t%s\t%s\n', ... % DEBUG:::
											i_cancelled,DITable(i_cancelled).logpos,get(LogControl,'value'), ...
											DITable(i_cancelled).InFile{1},DITable(i_cancelled).Func));
									end;
									vLogAdd(C_MSG_CANCELLED_TASK);
									DITable(i_cancelled).logpos = [];
								end;
                            end
                            aLog(C_MSG_CANCELLED_MAINMSG);
                        end;
						if VAR_DEBUG
							fprintf('CANCEL LIST END\n'); % DEBUG:::
							xLog('CANCEL LIST END\n'); % DEBUG:::
						end;
                        break;
                    end;
					
					DIthingsdone = DIthingsdone + 1;
					
					if VAR_ProfilingEnabled
						if ~plugin_calc % means that conversion to seconds isn't done yet
							if plugin_prof % means that the measure is done
								plugin_ends = plugin_ends - plugin_starts;
								if (plugin_ends(1) ~= 0) || (plugin_ends(2) ~= 0)
									plugin_prof = false;
								else
									plugin_ends_sec = plugin_ends(3:6)*[86400 3600 60 1]';
									if plugin_ends_sec == 0
										plugin_prof = false;
									else
										plugin_speed = all_samples / plugin_ends_sec;
									end;
								end;
							end;
						end;
						load_calc = false; save_calc = false;
						if plugin_prof % if we've got plugin time
							if ~load_prof % means there hasn't been any measurable load action
								if ~save_prof % means the same for saving
									plugin_ends_sec = plugin_ends_sec / 3;
									save_ends_sec = plugin_ends_sec; save_prof = true; save_calc = true;
									load_ends_sec = plugin_ends_sec; load_prof = true; load_calc = true;
									plugin_speed = plugin_ends_sec / all_samples;
									save_speed = save_ends_sec / all_samples;
									load_speed = load_ends_sec / all_samples;
								else % ~load save
									plugin_ends_sec = plugin_ends_sec / 2;
									load_ends_sec = plugin_ends_sec; load_prof = true; load_calc = true;
									plugin_speed = plugin_ends_sec / all_samples;
									load_speed = load_ends_sec / all_samples;
								end;
							else % load
								if ~save_prof % load ~save
									plugin_ends_sec = plugin_ends_sec / 2;
									save_ends_sec = plugin_ends_sec; save_prof = true; save_calc = true;
									plugin_speed = plugin_ends_sec / all_samples;
									save_speed = save_ends_sec / all_samples;
								else % load save
									; % nope
								end;
							end;
						end;
						if ~load_calc && load_prof
							load_ends = load_ends - load_starts;
							if (load_ends(1) ~= 0) || (load_ends(2) ~= 0)
								load_prof = false;
							else
								load_ends_sec = load_ends(3:6)*[86400 3600 60 1]';
								if load_ends_sec == 0
									load_prof = false;
								else
									load_speed = all_samples / load_ends_sec;
								end;
							end;
						end;
						if ~save_calc && save_prof
							save_ends = save_ends - save_starts;
							if (save_ends(1) ~= 0) || (save_ends(2) ~= 0)
								save_prof = false;
							else
								save_ends_sec = save_ends(3:6)*[86400 3600 60 1]';
								if save_ends_sec == 0
									save_prof = false;
								else
									save_speed = all_samples / save_ends_sec;
								end;
							end;
						end;
						% by now, if there's ..._prof, there's a valid ..._speed
					end; % if VAR_ProfilingEnabled

                end; % for i
				
                if UserModeNotice
                    vLog(C_MSG_USERMODE_SKIPPED);
                end;
				if AutoModeNotice
					vLog(C_MSG_AUTOMODE_SKIPPED);
				end;

                if ~isempty(i) && (i == DITableSize) && (DIthingstodo > 0)
                    aLog(sprintf(C_MSG_ALLDONE,fix(clock)));
                end;

            catch exception % -mutexPLUS----------------------------------

                mutexRELEASE;
                rethrow(exception); % v0.1.016

            end; % try-catch mutexPLUS

            mutexRELEASE;
            
        catch exception % -mutexMINUS-------------------------------------
		
			switch exception.identifier
				case { 'EEGbatch:ERROR_SAVING', 'EEGbatch:ERROR_LOADING', 'MATLAB:nomem' }
					aeLog(sprintf(C_MSG_ERRORPR,exception.message));
				otherwise
					aeLog(sprintf(C_MSG_INTERRORPR,exception.message));
			end;
			
			if VAR_DetailedExceptions
				stringtoreport = Exception2Report(exception);
				fprintf('%s',stringtoreport);
				if VAR_ErrorLog
					eLog(stringtoreport);
				elseif VAR_LogToFile
					fLog(stringtoreport);
				end;
			end;
			if VAR_ThrowExceptions,	rethrow(exception); end;
            
        end; % try-catch mutexMINUS
        
    end % func ProcessDITable
    
%
%
%
% -------------- BUILT-IN PLUGINS -----------------
%
%		function [funcres, EEG, logstr] = DO_PREP19(dataset,EEG,wtd,samplingrate,chanlocs)
%		function [funcres, EEG, logstr] = DO_PREPEDF(dataset,EEG,wtd,chanlocs,varargin)
%       function [funcres, EEG, logstr] = DO_ADDEVENTCH(dataset,EEG,wtd,stepby,event_col)
%       function [funcres, EEG, logstr] = DO_EVENTS(dataset,EEG,wtd,delevent,event_col)
%       function [funcres, EEG, logstr] = DO_EPOCHS(dataset,EEG,wtd,limit1,limit2,epochsamples)
%       function [funcres, EEG, logstr] = DO_BASELINE(dataset,EEG,wtd,rmb1,rmb2)
%       function [funcres, EEG, logstr] = DO_HIGHPASS(dataset,EEG,wtd,hpl)
%       function [funcres, EEG, logstr] = DO_LOWPASS(dataset,EEG,wtd,lpl)
%       function [funcres, EEG, logstr] = DO_THRESH(dataset,EEG,wtd,chstart,chend,epstart,epend,neglimit,poslimit,dropormark)
%       function [funcres, EEG, logstr] = USER_DROPEPOCH(dataset,EEG,wtd)
%       function [funcres, EEG, logstr] = USER_DROPCOMP(dataset,EEG,wtd)
%       function [funcres, EEG, logstr] = AUTO_DROPEPOCH(dataset,EEG,wtd,clearothers)
%       function [funcres, EEG, logstr] = AUTO_DROPCOMP(dataset,EEG,wtd)
%       function [funcres, EEG, logstr] = DO_IDROPCOMP(dataset,EEG,wtd,varargin)
%       function [funcres, ALLEEG, logstr] = DO_MULTI_ICA(dataset,ALLEEG,wtd,ICAtype,ICAoptions,ICAlogfile)
%       function [funcres, EEG, logstr] = DO_freqinrow(dataset,EEG,wtd,anteposte,leftright,bandbych,onefile,channelsaffected,bandsetupfile)
%       function [funcres, EEG, logstr] = DO_select(dataset,EEG,wtd,varargin)
%

    % preprocessing phase for 19-channel data, trim .M00, conversion to dataset
    function [funcres, EEG, logstr] = DO_PREP19(dataset,EEG,wtd,samplingrate,chanlocs)
  
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_PREP19_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        logstr = sprintf(C_MSG_PREP19_INIT,0,samplingrate,chanlocs);

        [dirname n e] = fileparts(dataset.FN);
        fn2 = strcat(dirname,'\',n,'_mod.txt');
        fh1 = fopen(dataset.FN);
        fh2 = fopen(fn2,'w');
        rej_lines = 0;

        try
            while (not(feof(fh1)))
                l = fgets(fh1);
                if (not(isletter(l(1))) && not(isletter(l(3))))
                    fwrite(fh2,l);
                else
                    rej_lines = rej_lines + 1;
                end;
            end; 
        catch exception
            fclose(fh2); fclose(fh1);
            rethrow(exception);
        end;

        fclose(fh2); fclose(fh1);

        logstr = strcat(logstr,13,10,sprintf(C_MSG_PREP19_REJLINES,rej_lines));

        EEG = pop_importdata('setname',PackSetname(dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond), ...
            'dataformat','ascii','data',fn2,'srate',samplingrate,'subject',dataset.Subj,'condition',dataset.Cond);
        
        if ~strcmpi(chanlocs,'')
            EEG.chanlocs = readlocs(chanlocs);
        end;
        
        funcres = 0;
    end

    % preprocessing phase, 64-channel, load EDF
    function [funcres, EEG, logstr] = DO_PREPEDF(dataset,EEG,wtd,chanlocs,varargin)

        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_PREPEDF_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        EEG = pop_readbdf(dataset.FN,varargin);
        EEG = eeg_checkset(EEG);
        if ~strcmpi(chanlocs,'')
            EEG.chanlocs = readlocs(chanlocs);
        end;
        
        logstr = sprintf(C_MSG_PREPEDF,EEG.ref,numel(EEG.event));

        funcres = 0;    
    end

    % adds event channel to the dataset
    function [funcres, EEG, logstr] = DO_ADDEVENTCH(dataset,EEG,wtd,stepby,event_col)
    
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_ADDEVENTCH_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        if numel(size(EEG.data)) > 2
            ME = MException('EEGbatch:DO_ADDEVENTCH_EPOCHEDALREADY',C_MSG_ADDEVENTCH_EPOCHERR);
            throw(ME);
        end;
        
        if nargin < 5
            event_col = numel(EEG.data(:,1)) + 1;
        end;
        
        evch = zeros(1,size(EEG.data,2));
        for i = 1:stepby:numel(evch)
            evch(i) = 1;
        end;
        if event_col > size(EEG.data,1)
            EEG.data = cat(1,EEG.data,evch);
        else
            EEG.data = cat(1,EEG.data(1:event_col-1,:),evch,EEG.data(event_col:end,:));
        end;
		
		EEG.nbchan = EEG.nbchan + 1; % v0.1.017
		if ~isempty(EEG.chanlocs)
			EEG.chanlocs(size(EEG.data,1)) = EEG.chanlocs(1);
			EEG.chanlocs(size(EEG.data,1)).labels = 'epevent';
			EEG.chanlocs(size(EEG.data,1)).X = 0;
			EEG.chanlocs(size(EEG.data,1)).Y = 0;
			EEG.chanlocs(size(EEG.data,1)).Z = 0;
			EEG.chanlocs(size(EEG.data,1)).theta = 0;
			EEG.chanlocs(size(EEG.data,1)).radius = 0;
			EEG.chanlocs(size(EEG.data,1)).sph_theta = 0;
			EEG.chanlocs(size(EEG.data,1)).sph_phi = 0;
			EEG.chanlocs(size(EEG.data,1)).sph_radius = 0;
			EEG.chanlocs(size(EEG.data,1)).type = '';
			EEG.chanlocs(size(EEG.data,1)).ref = '';
			EEG.chanlocs(size(EEG.data,1)).urchan = 0;
		end;
        
        EEG = eeg_checkset(EEG);
        
        logstr = sprintf(C_MSG_ADDEVENTCH,event_col);
        
        funcres = 0;    
    end

    function [funcres, EEG, logstr] = DO_EVENTS(dataset,EEG,wtd,delevent,event_col)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_EVENTS_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;

        if numel(size(EEG.data)) > 2
            ME = MException('EEGbatch:DO_EVENTS_EPOCHEDALREADY',C_MSG_EVENTS_EPOCHERR);
            throw(ME);
        end;        
        
        if nargin < 5
            % event_col = numel(EEG.data(:,1));
			event_col = size(EEG.data,1); % v0.1.020
        end;
        if nargin < 4
            delevent = 'off';
        end;

        EEG = pop_chanevent(EEG, event_col,'oper','X>0','edge','trailing','edgelen',0,'nbtype',1,'delchan','off','delevent',delevent); % delevent = on|off
        EEG = eeg_checkset(EEG);
        EEG.data(event_col,:) = [];             % triggerch. deletion
		EEG.nbchan = EEG.nbchan - 1;	% v0.1.017
		if ~isempty(EEG.chanlocs)
			EEG.chanlocs(event_col) = [];
		end;
        EEG = eeg_checkset(EEG);
        
        logstr = sprintf(C_MSG_EVENT,numel(EEG.event),event_col);
        
        funcres = 0;
    end

    function [funcres, EEG, logstr] = DO_EPOCHS(dataset,EEG,wtd,limit1,limit2,epochsamples)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_EPOCHS_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
		if (limit1==-1) && (limit2==-1)
			if nargin < 6
				ME = MException('EEGbatch:DO_EPOCHS_PARAMERROR',C_MSG_EPOCH_PARAMERROR);
				throw(ME);
			else
				limit1 = 0;
				limit2 = epochsamples/EEG.srate;
			end;
		end;
        EEG = pop_epoch( EEG, {  }, [limit1  limit2], 'newname', strcat(EEG.setname,' epochs'), 'epochinfo', 'yes');
        EEG = eeg_checkset(EEG);
		
		if numel(size(EEG.data)) > 2		% v0.1.017
			logstr = sprintf(C_MSG_EPOCH,limit1,limit2,size(EEG.data,2));
			funcres = 0;
		else
			logstr = sprintf(C_MSG_EPOCH_ERROR,limit1,limit2,size(EEG.data));
			funcres = -1;
		end;
    end

    function [funcres, EEG, logstr] = DO_BASELINE(dataset,EEG,wtd,rmb1,rmb2)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_BASELNE_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;

        if nargin < 4
            EEG = pop_rmbase( EEG, []);
            EEG = eeg_checkset( EEG );
            logstr = sprintf(C_MSG_BASELINE,-1,-1);
        else
            EEG = pop_rmbase( EEG, [rmb1 rmb2]);
            EEG = eeg_checkset( EEG );
            logstr = sprintf(C_MSG_BASELINE,rmb1,rmb2);
        end;

        funcres = 0;
    end

    function [funcres, EEG, logstr] = DO_HIGHPASS(dataset,EEG,wtd,hpl)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_HIGHPASS_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        EEG = pop_eegfilt( EEG, hpl, 0, [], [0]);
        EEG = eeg_checkset( EEG );
        
        logstr = sprintf(C_MSG_HIGHPASS,hpl);
        
        funcres = 0;
    end

    function [funcres, EEG, logstr] = DO_LOWPASS(dataset,EEG,wtd,lpl)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_LOWPASS_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        EEG = pop_eegfilt( EEG, 0, lpl, [], [0]);
        EEG = eeg_checkset( EEG );
        
        logstr = sprintf(C_MSG_LOWPASS,lpl);
        
        funcres = 0;
    end

    function [funcres, EEG, logstr] = DO_THRESH(dataset,EEG,wtd,chstart,chend,epstart,epend,neglimit,poslimit,dropormark) % v0.2.003 dropormark
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_THRESH_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        if chstart == -1
            chstart = 1;
            chend = size(EEG.data,1);
        end;
		if nargin < 10
			dropormark = 0;
		end;
        [EEG Ind] = pop_eegthresh(EEG,1,[chstart:chend],neglimit,poslimit,epstart,epend,1,0);
		if dropormark
			if (sum(Ind == 0) == 0) % v0.1.016
				EEG.data = [];
				if VAR_DISP, fprintf(C_DISP_THRESH_ALLGONE); end;
			else
				EEG = pop_rejepoch(EEG, Ind, 0);
			end;
		end;
		
        EEG = eeg_checkset(EEG);
        logstr = sprintf(C_MSG_THRESH,chstart,chend,neglimit,poslimit,num2str(Ind));
        funcres = 0;
    end

    function [funcres, EEG, logstr] = USER_DROPEPOCH(dataset,EEG,wtd)
		if VAR_DropEpoch_EEGLAB
			if ~strcmp(wtd,'run')
				ME = MException('EEGbatch:USER_DROPEPOCHeeglab_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
				throw(ME);
			end;
			
			[d n e] = fileparts(dataset.FN); n = [n e];
			if VAR_DISP, fprintf(C_DISP_DROPEPOCH_CONNECT,n); end;

			eeglab redraw;
			old_warning_state = warning('off','MATLAB:declareGlobalBeforeUse'); % v0.2.002
			global EEG;
			warning(old_warning_state);
			
			if VAR_DISP, fprintf(C_DISP_DROPEPOCH_CONNECTED); end;

			[answer, userremarks] = uiquestion([sprintf(C_MSG_DROPEPOCH_EEGL_Q,dataset.FN) '/usertext'],sprintf(C_MSG_DROPEPOCH_EEGL_Title,dataset.FN), ...
				'OK',C_MSG_DROPEPOCH_EEGL_OK, ...
				'CANCEL',C_MSG_DROPEPOCH_EEGL_CANCEL, ...
				'STOP',C_MSG_DROPEPOCH_EEGL_STOP);
				
			if VAR_DISP, fprintf(C_DISP_DROPEPOCH_FINISH); end;
			
			if strcmpi(answer,'OK')
				
				old_warning_state = warning('off','MATLAB:declareGlobalBeforeUse'); % v0.2.002
				global EEG;
				warning(old_warning_state);

				if sum(EEG.reject.rejmanual) > 0
					Ind = zeros(1,sum(EEG.reject.rejmanual));
					j = 1;
					for i = 1:numel(EEG.reject.rejmanual)
						if EEG.reject.rejmanual(i) == 1 % v0.1.020 %TODO fix this in the other as well
							Ind(j) = i;
							j = j + 1;
							if j > numel(Ind)
								break;
							end;
						end;
					end;
					funcres = 0;
				else
					Ind = [];
					funcres = 1;
				end;
				logstr = '';
				dropstr2 = sprintf('%u,',Ind); % dropstr2 because it makes the following code equivalent with one in the DO_DROPCOMP()
				if numel(dropstr2) > 0
					dropstr2 = dropstr2(1:end-1); % cut "," at the end
				end;
				if VAR_DropEpoch_MakeAuto
					makeautofn = sprintf(C_DROPEPOCH_MAKEAUTO_FILENAME_FORMAT,dataset.Prj,dataset.SubjGr);
					[d n e] = fileparts(dataset.FN);
					if d(end) ~= '\'
						d = strcat(d,'\');
					end;
					makeautofn = [d makeautofn];
					[mafh msg] = fopen(makeautofn,'a');
					if mafh > 0
						try
							fprintf(mafh,'%s\t%s\n',dataset.FN,dropstr2);
						catch exception
							fclose(mafh); mafh = 0;
							logstr = sprintf(C_MSG_DROPEPOCH_AUTOERR,makeautofn,exception.message);
							if VAR_ThrowExceptions,	rethrow(exception); end;
						end;
					else
						logstr = sprintf(C_MSG_DROPEPOCH_AUTOERR,makeautofn,msg);
					end;
					if mafh > 0
						fclose(mafh);
					end;
				end; % if VAR_DropEpoch_MakeAuto...
				
				if VAR_DropEpoch_SaveRejectStruct
					rejstructfn = sprintf(C_DROPEPOCH_REJECTSTRUCT_FILENAME_FORMAT,dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond);
					[d n e] = fileparts(dataset.FN);
					if d(end) ~= '\'
						d = strcat(d,'\');
					end;
					rejstructfn = [d rejstructfn];
					reject = EEG.reject;
					try
						save(rejstructfn,'reject');
					catch exception
						logstr = sprintf(C_MSG_DROPEPOCH_REJSAVEERR,rejstructfn,exception.message);
						if VAR_ThrowExceptions,	rethrow(exception); end;
					end;
				end;
			
				logstr = [logstr sprintf(C_MSG_DROPEPOCH,userremarks,num2str(Ind))];
				
				if VAR_DISP, fprintf(C_DISP_DROPEPOCH_INFOLINE,sum(EEG.reject.rejmanual),size(EEG.data,3),sum(EEG.reject.rejmanual)/size(EEG.data,3)*100); end;
			else % if answer ~= 'OK'
				logstr = sprintf(C_MSG_DROPEPOCH,['CANCEL-' userremarks],'');
				funcres = -1;
			end; % if answer ...
			
			if strcmpi(answer,'STOP')
				opStatus = OPS_TERMINATING; % v0.2.003 - experimental
			end;

		
		else % if not VAR_DropEpoch_EEGLAB
		
			% not working very well
			% at this version, keep VAR_DropEpoch_EEGLAB turned ON
		
			if ~strcmp(wtd,'run')
				ME = MException('EEGbatch:USER_DROPEPOCH_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
				throw(ME);
			end;
			
			mwh = findobj('Name',mainwindowname); setappdata(mwh,'TMPREJ',[]);
			
			command = ['mwh = findobj(''Name'',''',mainwindowname,'''); setappdata(mwh,''TMPREJ'',TMPREJ);'];

			eegplot( EEG.data, 'srate', EEG.srate, 'title', sprintf('USER_DROPEPOCH(): %s',dataset.FN), ...
				 'limits', [EEG.xmin EEG.xmax]*1000 , 'command', command); 
			waitfor(findobj('Name',sprintf('USER_DROPEPOCH(): %s',dataset.FN)));
	%        pause(2);
			mwh = findobj('Name',mainwindowname); TR = getappdata(mwh,'TMPREJ'); setappdata(mwh,'TMPREJ',[]);

			if ~isempty(TR)
				[EEG.reject.rejmanual, EEG.reject.rejmanualE] = eegplot2trial(TR,length(EEG.data(1,:,1)),EEG.trials);
				EEG = pop_rejepoch(EEG, EEG.reject.rejmanual, 0);
				
				Ind = zeros(1,sum(EEG.reject.rejmanual));
				j = 1;
				for i = 1:numel(EEG.reject.rejmanual)
					if EEG.reject.rejmanual == 1
						Ind(j) = i;
						j = j + 1;
						if j > numel(Ind)
							break;
						end;
					end;
				end;
				funcres = 0;
			else
				Ind = [];
				funcres = 1;
			end;
			
			logstr = sprintf(C_MSG_DROPEPOCH,'',num2str(Ind));

		
		end; % if VAR_DropEpoch_EEGLAB...
    end % func USER_DROPEPOCH
	
    function [funcres, EEG, logstr] = USER_DROPCOMP(dataset,EEG,wtd)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:USER_DROPCOMP_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;

        eeglab redraw;
		old_warning_state = warning('off','MATLAB:declareGlobalBeforeUse'); % v0.2.002
		global EEG;
		warning(old_warning_state);
        iwa = EEG.icaweights;
		
		if VAR_DropComp_PrtScr

			[answer, userremarks] = uiquestion([sprintf(C_MSG_DROPCOMP_Q_PRTSCR,dataset.FN) '/usertext'],sprintf(C_MSG_DROPCOMP_TITLE_PRTSCR,dataset.FN), ...
				'OK',C_MSG_DROPCOMP_OK, ...
				'CANCEL',C_MSG_DROPCOMP_CANCEL, ...
				'STOP', C_MSG_DROPCOMP_STOP);
				
		else

			[answer, userremarks] = uiquestion([sprintf(C_MSG_DROPCOMP_Q,dataset.FN) '/usertext'],sprintf(C_MSG_DROPCOMP_TITLE,dataset.FN), ...
				'OK',C_MSG_DROPCOMP_OK, ...
				'CANCEL',C_MSG_DROPCOMP_CANCEL, ...
				'STOP', C_MSG_DROPCOMP_STOP);
				
		end;
		
        
        if strcmpi(answer,'OK')
			dropstr = ''; dropstr2 = ''; dropcnt = 0;
            
			old_warning_state = warning('off','MATLAB:declareGlobalBeforeUse'); % v0.2.002
			global EEG;
			warning(old_warning_state);
		
            iwb = EEG.icaweights;
            
			for i = 1:size(iwa,1)
				found = 0;
				for j = 1:size(iwb,1)
					if all(iwa(i,:) == iwb(j,:))
						found = 1;
					end;
				end;
				if ~found
					dropcnt = dropcnt + 1;
					dropstr = [dropstr '[' sprintf('%.6f, ',iwa(i,:))];
					dropstr2 = [dropstr2 ';' sprintf('%.6f,',iwa(i,:))];
					dropstr = [dropstr(1:end-2) ']'];
					dropstr2 = dropstr2(1:end-1);
				end;
			end;
			if numel(dropstr2) > 0
				dropstr2 = dropstr2(2:end); % cut the first ";"
			end;
			
			if dropcnt == 0
				dropstr = '[]';
				dropstr2 = '';
			end;
            % log the result
            logstr = '';
			if VAR_DropComp_MakeAuto
				makeautofn = sprintf(C_DROPCOMP_MAKEAUTO_FILENAME_FORMAT,dataset.Prj,dataset.SubjGr);
				[d n e] = fileparts(dataset.FN);
				if d(end) ~= '\'
					d = strcat(d,'\');
				end;
				makeautofn = [d makeautofn];
				[mafh msg] = fopen(makeautofn,'a');
				if mafh > 0
					try
						fprintf(mafh,'%s\t%s\n',dataset.FN,dropstr2);
					catch exception
                        fclose(mafh); mafh = 0;
						logstr = sprintf(C_MSG_DROPCOMP_AUTOERR,makeautofn,exception.message);
						if VAR_ThrowExceptions,	rethrow(exception); end;
					end;
				else
					logstr = sprintf(C_MSG_DROPCOMP_AUTOERR,makeautofn,msg);
				end;
                if mafh > 0
                    fclose(mafh);
                end;
			else
				logstr = '';
			end;
			if VAR_DropComp_PrtScr
				[d n e] = fileparts(dataset.FN);
				if d(end) ~= '\'
					d = strcat(d,'\');
				end;
				prtscrfile = [d n '.DROPCOMP.jpg'];
				try
					a = imclipboard('paste', prtscrfile);
				catch
					a = [];
					if VAR_ThrowExceptions,	rethrow(exception); end;
				end;
				if numel(a) == 0
					prtscrfile = '';
					if VAR_DISP, fprintf(C_DISP_DROPCOMP_NOPRTSCR); end;
				else
					if VAR_DISP, fprintf(C_DISP_DROPCOMP_OKPRTSCR,prtscrfile); end;
				end;
			else
				prtscrfile = '';
			end;
			if strcmpi(prtscrfile,'')
				logstr = [logstr sprintf(C_MSG_DROPCOMP,dropcnt,userremarks,dropstr)];
			else
				logstr = [logstr sprintf(C_MSG_DROPCOMP_PRTSCR,dropcnt,userremarks,prtscrfile,dropstr)];
			end;
					
            funcres = 0;
        else
            logstr = sprintf(C_MSG_DROPCOMP,0,['CANCEL-' userremarks],'[]');
            funcres = -1;
        end; % if answer == 'OK'
		
		if strcmpi(answer,'STOP')
			opStatus = OPS_TERMINATING; % v0.2.003 - experimental
		end;
		
    end % func USER_DROPCOMP

	function [funcres, EEG, logstr] = AUTO_DROPEPOCH(dataset,EEG,wtd,clearothers)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:AUTO_DROPEPOCH_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end; 
		
		if nargin < 4
			clearothers = 0;
		end;
		
		makeautofn = sprintf(C_DROPEPOCH_MAKEAUTO_FILENAME_FORMAT,dataset.Prj,dataset.SubjGr);
		[d n e] = fileparts(dataset.FN);
		if d(end) ~= '\'
			d = strcat(d,'\');
		end;
		makeautofn = [d makeautofn];
		[mafh msg] = fopen(makeautofn,'r');
		logstr = ''; 
		funcres = 0; 
		foundentry = 0; % this will become string if the corresponding line will be found
		foundatline = 0; % this is the line nr where we found it
		if mafh > 0
			try
				s = fgets(mafh); 
				linenr = 1; % line number just for logging
				warningnr = 0; % counter of format warnings, won't be logged after 5
				toomuchwarn_added = 0; % too much warning message added to log
				while ~isnumeric(s)
					explode = regexp(s,'\t','split');
					if numel(explode) >= 2
						linefailed = 0;
						for i = 1:numel(explode{2})
							switch explode{2}(i)
								case {'.','-','+',',',';','0','1','2','3','4','5','6','7','8','9',' ',9,13,10}
									;
								otherwise
									funcres = 1;
									warningnr = warningnr + 1;
									if warningnr < 6
										logstr = [logstr sprintf(C_MSG_AUTODROPEPOCH_FORMATERR_WARN,makeautofn,linenr,explode{2}) ' /// '];
									end;
									linefailed = 1; 
							end; % switch
						end; % for
					else % if numel(explode) < 2
						funcres = 1;
						warningnr = warningnr + 1;
						if warningnr < 6 
							logstr = [logstr sprintf(C_MSG_AUTODROPEPOCH_TABERR_WARN,makeautofn,linenr) ' /// '];
						end;
						linefailed = 1; 
					end; % if numel(explode)...
					if (warningnr >= 6) && ~toomuchwarn_added
						toomuchwarn_added = 1;
						logstr = [logstr C_MSG_AUTODROPEPOCH_TOOMUCHWARN ' /// '];
					end; 
					if ~linefailed 
                        [Prj2, SubjGr2, Subj2, Cond2, ~] = UnpackFilename(strtrim(explode{1}));
						if strcmpi(dataset.Prj, Prj2) && ...
							strcmpi(dataset.SubjGr, SubjGr2) && ...
							strcmpi(dataset.Subj, Subj2) && ...
							strcmpi(dataset.Cond, Cond2) 
							if foundatline ~= 0
								logstr = [logstr C_MSG_AUTODROPEPOCH_AMBIRESULT_WARN ' /// '];
							end;
							foundentry = explode{2};
							foundatline = linenr;
						end;
					end;
					s = fgets(mafh); linenr = linenr + 1;
				end; % while
			catch exception
				fclose(mafh); mafh = 0;
				logstr = sprintf(C_MSG_AUTODROPEPOCH_FILEERR,makeautofn,exception.message);
				if VAR_ThrowExceptions,	rethrow(exception); end;
			end;
		else
			logstr = sprintf(C_MSG_AUTODROPEPOCH_FILEERR,makeautofn,msg);
		end;
		if mafh > 0
			fclose(mafh);
		end;
		if (foundatline == 0) || isnumeric(foundentry)
			logstr = [logstr C_MSG_AUTODROPEPOCH_NOTFOUND];
			funcres = -1;
		elseif strcmpi(strtrim(foundentry),'')
			logstr = [logstr sprintf(C_MSG_AUTODROPEPOCH_NTD,foundatline)];
			% funcres set already
		else % if found entry and it's not empty
			try
				targetepoch = eval(['[' foundentry ']']);
			catch exception
				logstr = [logstr sprintf(C_MSG_AUTODROPEPOCH_ERRORCONVERTING,foundatline,exception.message)];
				funcres = -3;
				if VAR_ThrowExceptions,	rethrow(exception); end;
				return;
			end;
			
			if clearothers || isempty(EEG.reject.rejmanual) || isempty(EEG.reject.rejmanualE)
				EEG.reject.rejmanual = (zeros(1,size(EEG.data,3)) == ones(1,size(EEG.data,3)));
				EEG.reject.rejmanualE = (zeros(size(EEG.data,1),size(EEG.data,3)) == ones(size(EEG.data,1),size(EEG.data,3)));
			end;
			
			for i = 1:numel(targetepoch)
				if (targetepoch(i) >= 1) & (targetepoch(i) <= numel(EEG.reject.rejmanual))
					EEG.reject.rejmanual(targetepoch(i)) = 1;
				else
					funcres = -4;
					logstr = [logstr sprintf(C_MSG_AUTODROPEPOCH_BOUNDSERR,foundatline,targetepoch(i))];
					return;
				end;
			end;
			
			% funcres set already
			logstr = [logstr sprintf(C_MSG_AUTODROPEPOCH_DONE,foundatline,numel(targetepoch))];			
		
		end; % if found entry and it's not empty
		
	end % func AUTO_DROPEPOCH
	
	function [funcres, EEG, logstr] = AUTO_DROPCOMP(dataset,EEG,wtd)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:AUTO_DROPCOMP_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end; 
		makeautofn = sprintf(C_DROPCOMP_MAKEAUTO_FILENAME_FORMAT,dataset.Prj,dataset.SubjGr);
		[d n e] = fileparts(dataset.FN);
		if d(end) ~= '\'
			d = strcat(d,'\');
		end;
		makeautofn = [d makeautofn];
		[mafh msg] = fopen(makeautofn,'r');
		logstr = ''; 
		funcres = 0; 
		foundentry = 0; % this will become string if the corresponding line will be found
		foundatline = 0; % this is the line nr where we found it
		if mafh > 0
			try
				s = fgets(mafh); 
				linenr = 1; % line number just for logging
				warningnr = 0; % counter of format warnings, won't be logged after 5
				toomuchwarn_added = 0; % too much warning message added to log
				while ~isnumeric(s)
					explode = regexp(s,'\t','split');
					if numel(explode) >= 2
						linefailed = 0;
						for i = 1:numel(explode{2})
							switch explode{2}(i)
								case {'.','-','+',',',';','0','1','2','3','4','5','6','7','8','9',' ',9,13,10}
									;
								otherwise
									funcres = 1;
									warningnr = warningnr + 1;
									if warningnr < 6
										logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_FORMATERR_WARN,makeautofn,linenr,explode{2}) ' /// '];
									end;
									linefailed = 1; 
							end; % switch
						end; % for
					else % if numel(explode) < 2
						funcres = 1;
						warningnr = warningnr + 1;
						if warningnr < 6 
							logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_TABERR_WARN,makeautofn,linenr) ' /// '];
						end;
						linefailed = 1; 
					end; % if numel(explode)...
					if (warningnr >= 6) && ~toomuchwarn_added
						toomuchwarn_added = 1;
						logstr = [logstr C_MSG_AUTODROPCOMP_TOOMUCHWARN ' /// '];
					end; 
					if ~linefailed 
                        [Prj2, SubjGr2, Subj2, Cond2, ~] = UnpackFilename(strtrim(explode{1}));
						if strcmpi(dataset.Prj, Prj2) && ...
							strcmpi(dataset.SubjGr, SubjGr2) && ...
							strcmpi(dataset.Subj, Subj2) && ...
							strcmpi(dataset.Cond, Cond2) 
							if foundatline ~= 0
								logstr = [logstr C_MSG_AUTODROPCOMP_AMBIRESULT_WARN ' /// '];
							end;
							foundentry = explode{2};
							foundatline = linenr;
						end;
					end;
					s = fgets(mafh); linenr = linenr + 1;
				end; % while
			catch exception
				fclose(mafh); mafh = 0;
				logstr = sprintf(C_MSG_AUTODROPCOMP_FILEERR,makeautofn,exception.message);
				if VAR_ThrowExceptions,	rethrow(exception); end;
			end;
		else
			logstr = sprintf(C_MSG_AUTODROPCOMP_FILEERR,makeautofn,msg);
		end;
		if mafh > 0
			fclose(mafh);
		end;
		if (foundatline == 0) || isnumeric(foundentry)
			logstr = [logstr C_MSG_AUTODROPCOMP_NOTFOUND];
			funcres = -1;
		elseif strcmpi(strtrim(foundentry),'')
			logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_NTD,foundatline)];
			% funcres set already
		else % if found entry and it's not empty
			try
				targetcomp = eval(['[' foundentry ']']);
			catch exception
				logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_ERRORCONVERTING,foundatline,exception.message)];
				funcres = -3;
				if VAR_ThrowExceptions,	rethrow(exception); end;
				return;
			end;
			
			if size(targetcomp,2) ~= size(EEG.data,1)
				logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_DIMMISMATCH,foundatline,size(targetcomp,2),size(EEG.data,1))];
				funcres = -4;
				return;
			end;
			
			CnD = zeros(size(targetcomp,1),2); % Components&Distances
			
			for i = 1:size(targetcomp,1)
				fprintf('Searching component %u...\n',i);
				mindist = Inf; mindist_j = 0;
				for j = 1:size(EEG.icaweights,1)
					if C_AUTODROPCOMP_FACTOR_INVARIANT
						cmp1 = targetcomp(i,1:end-1) / targetcomp(i,2:end);
						cmp2 = EEG.icaweights(j,1:end-1) / EEG.icaweights(j,2:end);
						dist = sum((cmp1-cmp2).^2).^(1/2); 
					else
						dist = sum((targetcomp(i,:)-EEG.icaweights(j,:)).^2).^(1/2);
					end;
					fprintf('\tdistance %u-%u: %f\n',i,j,dist);
					if dist < mindist
						mindist = dist;
						mindist_j = j;
					end; % if
				end; % for j
				CnD(i,1) = mindist_j;
				CnD(i,2) = mindist;
				if VAR_DISP, fprintf(C_DISP_AUTODROPCOMP_FOUNDCOMP,i,mindist_j,mindist,C_AUTODROPCOMP_MAXDISTANCE); end;
			end; % for i
			
			notclose = []; notclose_dist = [];
			for i = 1:size(CnD,1)
				if CnD(i,2) > C_AUTODROPCOMP_MAXDISTANCE
					notclose = [notclose i];
					notclose_dist = [notclose_dist CnD(i,2)];
				end;
			end;
			
			if ~isempty(notclose)
				notclose_s1 = sprintf('%u, ',notclose);
				notclose_s2 = sprintf('%f, ',notclose_dist);
				notclose_s1 = notclose_s1(1:end-2);
				notclose_s2 = notclose_s2(1:end-2);
				logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_COMPNOTFOUND,foundatline,size(targetcomp,1),notclose_s1,notclose_s2)];
				funcres = -2;
			else
				EEG = pop_subcomp( EEG, CnD(:,1)', 0);
				EEG = eeg_checkset( EEG );
				% funcres set already
				logstr = [logstr sprintf(C_MSG_AUTODROPCOMP_DONE,foundatline,size(targetcomp,1),sprintf('%f ',CnD(:,2)))];
			end;
			
		end; % if found entry and it's not empty
			
	end % func AUTO_DROPCOMP
	
	function [funcres, EEG, logstr] = DO_IDROPCOMP(dataset,EEG,wtd,varargin)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_IDROPCOMP_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end; 
		if nargin < 4
			ME = MException('EEGbatch:DO_IDROPCOMP_BADPARAM',C_MSG_IDROPCOMP_BADPARAM);
			throw(ME);
		end;
		
		% collect artefact channels
		artf_ch = zeros(1,nargin-3);
		for i = 1:nargin-3
			artf_ch(i) = varargin{i};
		end;
		
		iwa = EEG.icaweights;
		iwb = abs(iwa);
		rowsums = sum(iwb,2);
		for i = 1:size(iwb,1)
			iwb(i,:) = iwb(i,:) / rowsums(i);
		end;

		% for all components, sum the coefficients in bad channels
		comp_badness = [[1:size(iwb,1)]' sum(iwb(:,artf_ch),2)];
		
		% sort the list 
		comp_badness = sortrows(comp_badness,2);
		
		% last numel(artefact_channels) are gonna be dropped
		comptodrop = comp_badness(size(comp_badness,1)-numel(artf_ch)+1:size(comp_badness,1),1);
		EEG = pop_subcomp(EEG, comptodrop, 0); % v0.1.025 
		EEG = eeg_checkset( EEG );
		
		% prepare logging
		
		dropstr = ''; dropstr2 = ''; dropcnt = 0;
		
		for j = size(comp_badness,1):-1:size(comp_badness,1)-numel(artf_ch)+1
			i = comp_badness(j,1);
			dropcnt = dropcnt + 1;
			dropstr = [dropstr '[' sprintf('%.6f, ',iwa(i,:))];
			dropstr2 = [dropstr2 ';' sprintf('%.6f,',iwa(i,:))];
			dropstr = [dropstr(1:end-2) ']'];
			dropstr2 = dropstr2(1:end-1);
		end;
		
		if numel(dropstr2) > 0
			dropstr2 = dropstr2(2:end); % cut the first ";"
		end;
		
		artf_ch_str = sprintf('%u, ',artf_ch);
		artf_ch_str = [ '[' artf_ch_str(1:end-2) ']' ];
		badness_str = sprintf('%.3f%%, ',comp_badness(size(comp_badness,1):-1:size(comp_badness,1)-numel(artf_ch)+1,2)*100);
		badness_str = [ '[' badness_str(1:end-2) ']' ];
		
		% log the result
		logstr = '';
		if VAR_IDropComp_MakeAuto
			makeautofn = sprintf(C_IDROPCOMP_MAKEAUTO_FILENAME_FORMAT,dataset.Prj,dataset.SubjGr);
			[d n e] = fileparts(dataset.FN);
			if d(end) ~= '\'
				d = strcat(d,'\');
			end;
			makeautofn = [d makeautofn];
			[mafh msg] = fopen(makeautofn,'a');
			if mafh > 0
				try
					fprintf(mafh,'%s\t%s\n',dataset.FN,dropstr2);
				catch exception
					fclose(mafh); mafh = 0;
					logstr = sprintf(C_MSG_IDROPCOMP_AUTOERR,makeautofn,exception.message);
					if VAR_ThrowExceptions,	rethrow(exception); end;
				end;
			else
				logstr = sprintf(C_MSG_IDROPCOMP_AUTOERR,makeautofn,msg);
			end;
			if mafh > 0
				fclose(mafh);
			end;
		else
			logstr = '';
		end;
		logstr = [logstr sprintf(C_MSG_IDROPCOMP,numel(artf_ch),artf_ch_str,badness_str,dropstr)];
				
		funcres = 0;
	end

    function [funcres, ALLEEG, logstr] = DO_MULTI_ICA(dataset,ALLEEG,wtd,ICAtype,ICAoptions,ICAlogfile)
        if ~strcmp(wtd,'run')
            ME = MException('EEGbatch:DO_MULTI_ICA_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
            throw(ME);
        end;
        
        funcres = numel(ALLEEG);

        try
            if strcmp(ICAlogfile,'')
                ALLEEG = pop_runica(ALLEEG, 'icatype', ICAtype, 'dataset', 1:numel(ALLEEG), ...
                                    'concatenate','on','options',eval( [ '{ ' ICAoptions ' }' ] ));
            else
                ALLEEG = pop_runica(ALLEEG, 'icatype', ICAtype, 'dataset', 1:numel(ALLEEG), ...
                                    'concatenate', 'on', 'options',eval( [ '{ ' ICAoptions ' ''logfile'' ''' ICAlogfile ''' }' ] ));
            end;
        catch exception 
            if strcmp(exception.message, 'USER ABORT')
                funcres = C_ICA_USERABORT_CODE;
            else
                rethrow(exception);
            end;
        end;
        
        log_conds = ALLEEG(1).condition;
        for i = 2:numel(ALLEEG)
            log_conds = strcat(log_conds,'|',ALLEEG(i).condition);
        end;
        
        logstr = sprintf(C_MSG_ICA,ICAtype,ICAoptions,ICAlogfile,log_conds);
        
        % funcres handled earlier
    end
	
	function [funcres, EEG, logstr] = DO_freqinrow(dataset,EEG,wtd,anteposte,leftright,bandbych,onefile,channelsaffected,bandsetupfile)

		% generating filenames
		if onefile 
			outfn = sprintf(C_FREQINROW_ONEFILE_OUTFN,dataset.Prj);
			testfn = sprintf(C_FREQINROW_ONEFILE_TESTFN,dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond);
			headerfn = sprintf(C_FREQINROW_ONEFILE_HDRFN,dataset.Prj);
		else
			outfn = sprintf(C_FREQINROW_MULTIFILE_OUTFN,dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond);
			testfn = sprintf(C_FREQINROW_MULTIFILE_TESTFN,dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond);
			headerfn = sprintf(C_FREQINROW_MULTIFILE_HDRFN,dataset.Prj,dataset.SubjGr,dataset.Subj,dataset.Cond);
		end;
		
		[d, ~, e] = fileparts(dataset.FN);
		if d(end) ~= '\'
			d = strcat(d,'\');
		end;
		
		outfn = strcat(d,outfn);
		headerfn = strcat(d,headerfn);
		testfn = strcat(d,testfn);
		
		logstr = '';
		
		% 'check' phase
		
		if strcmp(wtd,'check') 
			if exist(testfn,'file')
				funcres = 0;
			else
				funcres = 1;
			end;
			return;
		end;
		
		% initializing variables
		
		if (nargin >= 9) 
			if isempty(strfind(bandsetupfile,'\'))
				bandsetupfile = strcat(d,bandsetupfile); % see outfn, headerfn
			end;
			[bsfh msg] = fopen(bandsetupfile,'r');
			if bsfh <= 0
				ME = MException('EEGbatch:DO_FREQINROW_FILEERR0R',C_MSG_FREQINROW_NOBANDFILE,bandsetupfile,msg);
				throw(ME);
			end;
			Bands = cell(3,1);
			try
				s = fgets(bsfh); i = 1;
				while ~isnumeric(s)
					explode = strtrim(regexp(s,'\t','split'));
					Bands{1,i} = explode{1};
					Bands{2,i} = str2double(explode{2});
					Bands{3,i} = str2double(explode{3});
					i = i + 1;
					s = fgets(bsfh);
				end; % while
			
			catch exception
				fclose(bsfh);
				rethrow(exception);
			end;
			fclose(bsfh);
		else % no bandsetupfile, using the default setup
			Bands = C_FREQINROW_DEFAULTBANDS;
		end; % if nargin
		
		CH_Ante = []; Bound_Ante = C_FREQINROW_ELECTRODE_ANTE;
		CH_Poste = []; Bound_Poste = C_FREQINROW_ELECTRODE_POSTE;
		CH_Left = []; Bound_Left = C_FREQINROW_ELECTRODE_LEFT;
		CH_Right = []; Bound_Right = C_FREQINROW_ELECTRODE_RIGHT;

		Bound_OutOfHead = C_FREQINROW_ELECTRODE_OUTOFHEAD;
		Bound_Invalid = C_FREQINROW_ELECTRODE_INVALID;
		
		% anterior-posterior,left-right separation based on coords found in .chanlocs
		if isempty(EEG.chanlocs)
			if anteposte || leftright
				logstr = C_MSG_FREQINROW_NOCHANLOCS;
				anteposte = 0; leftright = 0;
			end;
		else
			for i = 1:numel(EEG.chanlocs)
				dist = sqrt(EEG.chanlocs(i).X^2+EEG.chanlocs(i).Y^2+EEG.chanlocs(i).Z^2);
				bycoords_ap = 0;
				bycoords_lr = 0;
				%if (dist > Bound_OutOfHead) || (dist < Bound_Invalid)
				%	continue;
				%end;
				if ~isempty(dist) && (dist < Bound_OutOfHead) && (dist > Bound_Invalid) % v0.2.003
					if anteposte
						if EEG.chanlocs(i).X > Bound_Ante
							CH_Ante = [CH_Ante i];
							bycoords_ap = 1;
						end;
						if EEG.chanlocs(i).X < Bound_Poste
							CH_Poste = [CH_Poste i];
							bycoords_ap = 1;
						end;
					end;
					if leftright 
						if EEG.chanlocs(i).Y > Bound_Left
							CH_Left = [CH_Left i];
							bycoords_lr = 1;
						end;
						if EEG.chanlocs(i).Y < Bound_Right
							CH_Right = [CH_Right i];
							bycoords_lr = 1;
						end;
					end;
				end;
			end; % for i
		end; % if ~isempty(chanlocs)
		
		if VAR_DISP
			CH_Ante_str = sprintf('%u,',CH_Ante);
			CH_Poste_str = sprintf('%u,',CH_Ante);
			CH_Left_str = sprintf('%u,',CH_Ante);
			CH_Right_str = sprintf('%u,',CH_Ante);
			CH_Ante_str = CH_Ante_str(1:end-1);
			CH_Poste_str = CH_Poste_str(1:end-1);
			CH_Left_str = CH_Left_str(1:end-1);
			CH_Right_str = CH_Right_str(1:end-1);
			fprintf(C_DISP_FREQINROW_ANTEPOSTE,numel(CH_Ante),numel(CH_Poste),numel(CH_Left),numel(CH_Right), ...
				CH_Ante_str,CH_Poste_str,CH_Left_str,CH_Right_str);
		end;
		
		% producing header line
			
		header_line = sprintf('%s,',C_MSG_FREQINROW_HEADER_PRJ,C_MSG_FREQINROW_HEADER_SUBJ,C_MSG_FREQINROW_HEADER_SUBJGR,C_MSG_FREQINROW_HEADER_COND);
		header_line = [header_line sprintf('%s,',C_MSG_FREQINROW_HEADER_EPOCHCOUNT,C_MSG_FREQINROW_HEADER_EPOCHNR)];
		header_line = [header_line sprintf('%s,',C_MSG_FREQINROW_HEADER_MARKED1,C_MSG_FREQINROW_HEADER_MARKED2,C_MSG_FREQINROW_HEADER_MARKED3,C_MSG_FREQINROW_HEADER_MARKED4,C_MSG_FREQINROW_HEADER_MARKED5,C_MSG_FREQINROW_HEADER_MARKED6,C_MSG_FREQINROW_HEADER_MARKED7)];
		
		header_line = [header_line sprintf('%s,',Bands{1,:})];
		
		for i = 1:size(Bands,2)
			header_line = [header_line C_MSG_FREQINROW_HEADER_ANTE_PREFIX Bands{1,i} ',' ];
		end;
		for i = 1:size(Bands,2)
			header_line = [header_line C_MSG_FREQINROW_HEADER_POSTE_PREFIX Bands{1,i} ',' ];
		end;
		for i = 1:size(Bands,2)
			header_line = [header_line C_MSG_FREQINROW_HEADER_LEFT_PREFIX Bands{1,i} ',' ];
		end;
		for i = 1:size(Bands,2)
			header_line = [header_line C_MSG_FREQINROW_HEADER_RIGHT_PREFIX Bands{1,i} ',' ];
		end;
		for i = 1:size(Bands,2)
			for j = 1:numel(channelsaffected)
				if ~isempty(EEG.chanlocs)
					header_line = [header_line EEG.chanlocs(channelsaffected(j)).labels '_' Bands{1,i} ',' ];
				else
					header_line = [header_line sprintf(C_MSG_FREQINROW_HEADER_CH_NR,channelsaffected(j)) '_' Bands{1,i} ',' ];
				end;
			end;
		end;
		header_line = [header_line(1:end-1) sprintf('\n')];
		
		% create header file/datafile if it doesn't exist

		if ~exist(headerfn,'file')
			[fhh msg] = fopen(headerfn,'w');
			if fhh <= 0
				ME = MException('EEGbatch:DO_FREQINROW_FILEERR1',C_MSG_FREQINROW_FILEERR1,headerfn,msg);
				throw(ME);
			end;
			try
				fprintf(fhh,header_line);
			catch exception
				fclose(fhh);
				rethrow(exception);
			end;
			fclose(fhh);
		end;
		
		% generate main csv file/datafile
		
		[fh msg] = fopen(outfn,'a');
		
		if fh <= 0
			ME = MException('EEGbatch:DO_FREQINROW_FILEERR2',C_MSG_FREQINROW_FILEERR2,outfn,msg);
			throw(ME);
		end;
		
		tic;
		starttime = clock;
		
		try
			
			for epi = 1:size(EEG.data,3) % for all epochs
			
				if VAR_DISP
					t = toc;
					if (t > 1) && (epi > 3)
						alltime = t/epi*size(EEG.data,3);
						eta_s = starttime(6)+alltime;
						eta_m = starttime(5);
						eta_h = starttime(4);
						eta_h = eta_h + floor(eta_s/3600);
						eta_m = eta_m + floor(eta_s/60);
						eta_s = floor(rem(eta_s,60));
						fprintf(C_DISP_FREQINROW_PROCESSING,epi,size(EEG.data,3),eta_h,eta_m,eta_s);
					else
						fprintf(C_DISP_FREQINROW_PROCESSING,epi,size(EEG.data,3),0,0,0);
					end;
				end; % VAR_DISP
			
				rejman = ~isempty(EEG.reject.rejmanual) && EEG.reject.rejmanual(epi);
				rejjp = ~isempty(EEG.reject.rejjp) && EEG.reject.rejjp(epi);
				rejkurt = ~isempty(EEG.reject.rejkurt) && EEG.reject.rejkurt(epi);
				rejthr = ~isempty(EEG.reject.rejthresh) && EEG.reject.rejthresh(epi);
				rejcon = ~isempty(EEG.reject.rejconst) && EEG.reject.rejconst(epi);
				rejfreq = ~isempty(EEG.reject.rejfreq) && EEG.reject.rejfreq(epi);

				if C_FREQINROW_OLDMARK_ARTEFACT %TODO completely cut out % v0.1.024
					rejmark = ~isempty(EEG.reject.rejconst) && EEG.reject.rejconst(epi);
					rejcon = 0;
					%marked_epoch = rejman * 1 | rejjp * 2 | rejkurt * 4 | rejthr * 8 | ...
					%	0 * 16 | rejfreq * 32 | rejmark * 64;
				else
					rejmark = ~isempty(EEG.reject.rejmark) && EEG.reject.rejmark(epi);
					%marked_epoch = rejman * 1 | rejjp * 2 | rejkurt * 4 | rejthr * 8 | ...
					%	rejcon * 16 | rejfreq * 32 | rejmark * 64;
				end;
				
				% marked_epoch = rejman || rejjp || rejkurt || rejthr || rejcon || rejfreq;
				% outdated % v0.2.003
				
				% if rejmark
				% 	marked_epoch = 2;
				% end;
				% outdated % v0.2.003
			
				[spectra freqheader] = spectopo(EEG.data(channelsaffected,:,epi),0,EEG.srate,'plot','off'); 
				
				if size(spectra,1) ~= numel(channelsaffected) % not as many rows in spectra as many channels -> some channels have problems
					ME = MException('EEGbatch:DO_FREQINROW_CHANNELERR',C_MSG_FREQINROW_CHANNELERR);
					throw(ME);
				end;

				BandSelector = zeros(size(Bands,2),numel(freqheader));	% for all band, this will contain a list of the
																		% lines in 'spectra' that falls into the band's
																		% bounds
				BandSelectorIndex = ones(size(Bands,2),1);				% this will contain the pointer containing where
																		% to put the next line
				BandAvgByChannel = zeros(numel(channelsaffected),size(Bands,2));

				BandAvgAnte = zeros(numel(CH_Ante),size(Bands,2));
				BandAvgPoste = zeros(numel(CH_Poste),size(Bands,2));
				BandAvgLeft = zeros(numel(CH_Left),size(Bands,2));
				BandAvgRight = zeros(numel(CH_Right),size(Bands,2));
				BandAvgAnteAvg = zeros(size(Bands,2),1);
				BandAvgPosteAvg = zeros(size(Bands,2),1);
				BandAvgLeftAvg = zeros(size(Bands,2),1);
				BandAvgRightAvg = zeros(size(Bands,2),1);
				BandAvgAllChannels = zeros(size(Bands,2),1);
				for freqi = 1:numel(freqheader) % for all frequencies
					for bandi = 1:size(Bands,2) % for all bands
						if ((freqheader(freqi)>=Bands{2,bandi}) && (freqheader(freqi)<=Bands{3,bandi})) % if freq falls into the band
							BandSelector(bandi,BandSelectorIndex(bandi)) = freqi;
							BandSelectorIndex(bandi) = BandSelectorIndex(bandi) + 1;
						end; % if freq falls into
					end; % for all bands
				end; % for all freqs
				
				for bandi = 1:size(Bands,2) % for all bands 
					BandSelectorIndex(bandi) = BandSelectorIndex(bandi) - 1; % decrease all BandSelectorIndexes
					if BandSelectorIndex(bandi) == 0 % and check for non-emptyness
						ME = MException('EEGbatch:DO_FREQINROW_NOBAND',C_MSG_FREQINROW_EMPTYBAND,Bands{1,bandi},Bands{2,bandi},Bands{3,bandi});
						throw(ME);
					end;
					
					BandAvgByChannel(:,bandi) = mean(spectra(:,BandSelector(bandi,1:BandSelectorIndex(bandi))),2);
					% calc band spectra averages channel by channel
					BandAvgAllChannels(bandi) = mean(BandAvgByChannel(:,bandi),1);
					% and calc the great average for all bands (for this epoch)
					
					if anteposte % do the same restricted to the anterior/posterior channels
						BandAvgAnte(:,bandi) = mean(spectra(CH_Ante,BandSelector(bandi,1:BandSelectorIndex(bandi))),2);
						BandAvgPoste(:,bandi) = mean(spectra(CH_Poste,BandSelector(bandi,1:BandSelectorIndex(bandi))),2);
						BandAvgAnteAvg(bandi) = mean(BandAvgAnte(:,bandi),1);
						BandAvgPosteAvg(bandi) = mean(BandAvgPoste(:,bandi),1);
					end;
					if leftright % do the same restricted to the left/right channels
						BandAvgLeft(:,bandi) = mean(spectra(CH_Left,BandSelector(bandi,1:BandSelectorIndex(bandi))),2);
						BandAvgRight(:,bandi) = mean(spectra(CH_Right,BandSelector(bandi,1:BandSelectorIndex(bandi))),2);
						BandAvgLeftAvg(bandi) = mean(BandAvgLeft(:,bandi),1);
						BandAvgRightAvg(bandi) = mean(BandAvgRight(:,bandi),1);
					end;
				end; % for bandi
				
				% producing output line for SPSS
				
				SPSS_line = sprintf('%s,',dataset.Prj,dataset.Subj,dataset.SubjGr,dataset.Cond);
				SPSS_line = [SPSS_line sprintf('%u,',size(EEG.data,3),epi)];
				SPSS_line = [SPSS_line sprintf('%u,',rejmark,rejman,rejjp,rejkurt,rejthr,rejcon,rejfreq)];

				SPSS_line = [SPSS_line sprintf('%f,',BandAvgAllChannels)];
				if anteposte
					SPSS_line = [SPSS_line sprintf('%f,',BandAvgAnteAvg)];
					SPSS_line = [SPSS_line sprintf('%f,',BandAvgPosteAvg)];
				else
					SPSS_line = [SPSS_line sprintf('%f,',zeros(numel(BandAvgAnteAvg),1))];
					SPSS_line = [SPSS_line sprintf('%f,',zeros(numel(BandAvgPosteAvg),1))];
				end;
				if leftright
					SPSS_line = [SPSS_line sprintf('%f,',BandAvgLeftAvg)];
					SPSS_line = [SPSS_line sprintf('%f,',BandAvgRightAvg)];
				else
					SPSS_line = [SPSS_line sprintf('%f,',zeros(numel(BandAvgLeftAvg),1))];
					SPSS_line = [SPSS_line sprintf('%f,',zeros(numel(BandAvgRightAvg),1))];
				end;
				if bandbych
					SPSS_line = [SPSS_line sprintf('%f,',BandAvgByChannel)];
				else
					SPSS_line = [SPSS_line sprintf('%f,',zeros(size(BandAvgByChannel)))];
				end;
				SPSS_line = [SPSS_line(1:end-1) sprintf('\n')];
				
				fprintf(fh,SPSS_line);
				
				drawnow;
				
			end; % for all epochs
			
		catch exception
			fclose(fh);
			if VAR_ThrowExceptions, rethrow(exception); end;
			return;
			
		end;
		
		fclose(fh);
		
		% mark that we've finished
		
		if ~exist(testfn,'file')	% maybe it's common or the same as the datafile or exists for some other reason
			fhhh = fopen(testfn,'w');
			fclose(fhhh);
		end;
		
		logstr = [logstr sprintf(C_MSG_FREQINROW,6+7+numel(BandAvgAllChannels)+ ...
			numel(BandAvgAnteAvg)+numel(BandAvgPosteAvg)+numel(BandAvgLeftAvg)+numel(BandAvgRightAvg)+ ...
			numel(BandAvgByChannel),size(EEG.data,3),outfn)];
			
		if VAR_DISP, fprintf(C_DISP_FREQINROW_DONE,6+7+numel(BandAvgAllChannels)+ ...
			numel(BandAvgAnteAvg)+numel(BandAvgPosteAvg)+numel(BandAvgLeftAvg)+numel(BandAvgRightAvg)+ ...
			numel(BandAvgByChannel),size(EEG.data,3),outfn); end;
			
		funcres = 0;
				
	end	
	
	function [funcres, EEG, logstr] = DO_select(dataset,EEG,wtd,varargin)	

			if ~strcmp(wtd,'run')
				ME = MException('EEGbatch:DO_select_NOSELFCHECK',C_MSG_PLUGIN_CANNOT_SELFCHECK);
				throw(ME);
			end;

		
		EEG = pop_select( EEG, varargin{:} );
		EEG = eeg_checkset( EEG );

		logstr = [C_MSG_SELECT num2str(size(EEG.data))];
		funcres = 0;
		
	end	
%
%
%
% -------------- MAIN FUNCTION --------------------
%
%
%		

old_warning_state = warning('off','MATLAB:declareGlobalBeforeUse'); % v0.2.002
global ALLEEG EEG; % v0.1.017 experimental % v0.2.002 it seems to be working great :)
warning(old_warning_state);

[settingsfile n e] = fileparts(which('EEGbatch.m'));
if settingsfile(end) ~= '\'
	settingsfile = strcat(settingsfile,'\');
end;
settingsfile = [settingsfile 'EEGbatch_options.m']; 
LoadSettings(settingsfile);

try
	s = eeg_getversion;
	
catch exception
	if strcmpi(exception.identifier,'MATLAB:UndefinedFunction')
		fprintf(C_MSG_NOEEGLAB_ERR);
		return;
	else 
		rethrow(exception);
	end;
end;

dialog_create(VAR_AutoSelect,VAR_AutoRun);

%waitfor(MainDialog); % v0.1.025 temporarily disabled ---> SaveSettingsBtn introduced instead
%SaveSettings(settingsfile);

% ::DEBUG::START

%                dialog_OPTableEditor;
%for i = 1:OPTableSize
%    vLog(sprintf('resaveOP: %s, %u',OPTableNames(i).FileName,SaveOPTableFN(OPTableNames(i).FileName,OPTables(i,:))));
%end;
    
                
% ::DEBUG::END
                    


end