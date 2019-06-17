%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                             %
%   EEGbatch: Batch processing extension for EEGLAB toolbox   %
%   (installs itself as an EEGLAB plugin)                     %
%   [ https://sccn.ucsd.edu/eeglab/ ]                         %
%   Written by:         K�roly BARANYI                        %
%                    [ eegbatch@gmail.com ]                   %
%                            2012                             %
%                                                             %
%   version: 0.2--2012-07-30                                  %
%                                  Hungarian translation      %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ! Note: this is not an .m file to be called separately, you should 
% rather replace the main file's "TRANSLATE" part to the one in this
% in order to switch all EEGbatch messages to hungarian.

% ! Megjegyz�s: ez nem �nmag�ban futtatand� .m f�jl, haszn�lata:
% a "TRANSLATE" r�szt kell kicser�lni erre a fo futtathat� f�jlban.

%
%
%
% ----------------- TRANSLATE ---------------------
%
%
%
C_MSG_NOEEGLAB_ERR = 'HIBA: EEGLAB nincs bet�ltve. El�bb ind�tsd el az EEGLAB-ot! \nAz EEGbatch most kil�p.\n';
C_MSG_VLOGCLC = 'A k�perny�log el�rte a %u sort, �jrakezdt�k. (A f�jllog �s a t�bbi �rintetlen.)';
C_MSG_OPT_RATIO_INFOLINE1 = '[opt_ratio: ON  opt_ratio_planned %u opt_ratio_all %u opt_ratio_skipped %u opt_ratio_mutexed %u]';
C_MSG_OPT_RATIO_INFOLINE2 = '[opt_ratio: OFF opt_ratio_planned %u opt_ratio_all %u opt_ratio_skipped %u opt_ratio_mutexed %u]';
C_MSG_PI_MTX_WAITING = 'V�rakoz�s m�g %s el�rhet� lesz (max %u m�sodpercig)...';
C_MSG_ELOG_MTX_WAITING = 'V�rakoz�s m�g %s el�rhet� lesz (max %u m�sodpercig)...';
C_MSG_XLOG_MTX_WAITING = 'V�rakoz�s m�g %s el�rhet� lesz (max %u m�sodpercig)...';
C_MSG_OPTABLECHANGED_EXTTYPES = {'*.txt','Text files (*.txt)';'*.*','All files (*.*)'};
C_MSG_DROPCOMP_Q = 'A jelenlegi f�zisban k�rlek, v�laszd ki az EEGLAB Tools men�j�b�l a Reject data using ICA, azon bel�l a Reject components by map men�pontot! Ha ezzel v�gezt�l, akkor pedig ugyancsak a Tools men� Remove components men�pontj�t, v�g�l nyomd meg az OK gombot.';
C_MSG_DROPCOMP_TITLE = '%s';
C_MSG_DROPCOMP_Q_PRTSCR = 'A jelenlegi f�zisban k�rlek, v�laszd ki az EEGLAB Tools men�j�b�l a Reject data using ICA, azon bel�l a Reject components by map men�pontot! Ha ezzel v�gezt�l, fot�zd le a PrtScr (Print Screen) gombbal, majd pedig ugyancsak a Tools men� Remove components men�pontj�t, v�g�l nyomd meg az OK gombot.';
C_MSG_DROPCOMP_TITLE_PRTSCR = '%s';
C_MSG_DROPCOMP_OK = 'OK';
C_MSG_DROPCOMP_CANCEL = 'Ne mentsd';
C_MSG_DROPCOMP_STOP = 'Ne �s �LLJ!';
C_MSG_DROPCOMP_AUTOERR = 'DROPCOMP automatiz�l�si hiba %s f�jl �r�sakor (a m�velet ett�l m�g sikeres lehet): %s /// ';
C_MSG_DROPEPOCH_EEGL_Q = 'A jelenlegi f�zisban k�rlek, v�laszd ki az EEGLAB Tools men�j�b�l a Reject data epochs-t, azon bel�l a Reject by inspection men�pontot! Ha v�gezt�l, nyomd meg az OK gombot.';
C_MSG_DROPEPOCH_EEGL_Title = '%s';
C_MSG_DROPEPOCH_EEGL_OK = 'OK';
C_MSG_DROPEPOCH_EEGL_CANCEL = 'Ne mentsd';
C_MSG_DROPEPOCH_EEGL_STOP = 'Ne �s �LLJ!';
C_MSG_DROPEPOCH_AUTOERR = 'DROPEPOCH automatiz�l�si hiba %s f�jl �r�sakor (a m�velet ett�l m�g sikeres lehet): %s /// ';
C_MSG_DROPEPOCH_REJSAVEERR = 'DROPEPOCH automatiz�l�si hiba %s f�jl �r�sakor (a m�velet ett�l m�g sikeres lehet): %s /// ';
C_DISP_DROPEPOCH_CONNECT = '%s: csatlakoz�s az EEGLAB-hoz...';
C_DISP_DROPEPOCH_CONNECTED = 'Rendben\nV�rakoz�s a felhaszn�l�ra...';
C_DISP_DROPEPOCH_FINISH = 'Rendben, feldolgoz�s �s ment�s\n';
C_DISP_DROPEPOCH_INFOLINE = 'Megjel�lve %u epoch %u-b�l, %.1f %%\n';
C_MSG_LOGFILE_INIT = 'EEGbatch %s@%s indul';
C_MSG_PREP19_INIT = 'Adatf�jl el�k�sz�t�se';
C_MSG_EVENT = 'l�trehozva %u event a %u csatorn�b�l';
C_MSG_EPOCH = 'epochok l�trehozva (%f-%f, egy event %u pont hossz�)';
C_MSG_EPOCH_ERROR = 'hiba epoch l�trehoz�s k�zben (%f-%f), az adatt�mb nem v�lt sz�t: %u x %u';
C_MSG_EPOCH_PARAMERROR = 'Ha az DO_EPOCHS k�t limit-param�tere -1 (mint jelen esetben), akkor a harmadik param�terben v�rja az epoch sample-ben megadott k�v�nt hossz�t!';
C_MSG_BASELINE = 'baseline remove (%i;%i)';
C_MSG_HIGHPASS = 'highpass (%f)';
C_MSG_LOWPASS = 'lowpass (%f)';
C_MSG_THRESH = 'gyan�s �rt�kek sz�r�se, csatorn�k: %u-%u, als� hat�r: %u, fels� hat�r: %u, eldobott epochok: %s';
C_MSG_DROPEPOCH = 'k�zi epoch-eldob�s, megjegyz�s [%s], a kiv�lasztott epochok: [%s]'; % v0.1.020
C_MSG_DROPCOMP = 'komponensek elt�vol�t�sa, elt�vol�tva %u komponens, megjegyz�s [%s], komponensek egy�tthat�i: %s';
C_MSG_DROPCOMP_PRTSCR = 'komponensek elt�vol�t�sa, elt�vol�tva %u komponens, megjegyz�s [%s], k�perny�k�p-f�jl: [%s], komponensek egy�tthat�i: [%s]';
C_DISP_DROPCOMP_OKPRTSCR = 'USER_DROPCOMP: %s k�p mentve a v�g�lapr�l\n'; % v0.2.002
C_DISP_DROPCOMP_NOPRTSCR = 'USER_DROPCOMP: Nincs k�p a v�g�lapon!\n';
C_MSG_IDROPCOMP_BADPARAM = 'A DO_IDROPCOMP-nak meg kell adni m�term�k-csatorn�kat! Val�sz�n�leg rosszul form�zott az OPtable';
C_MSG_IDROPCOMP_AUTOERR = C_MSG_DROPCOMP_AUTOERR;
C_MSG_IDROPCOMP = 'komponensek m�term�kcsatorn�n alapul� elt�vol�t�sa (IDROPCOMP), elt�vol�tva %u komponens, m�term�k-csatorn�k [%s], az elt�vol�tott komponensek �rintetts�ge ezekb�l: %s, a komponensek egy�tthat�i: %s';
C_DISP_THRESH_ALLGONE = 'Vigy�zat, a DO_THRESH mindent ki�rtott! T�l szigor� felt�telek?\n';
C_MSG_ICA = 'ICA [type:%s] [options:%s] [logfile:%s] [conditions:%s]';
C_MSG_PREP19_REJLINES = 't�r�lve %u sor fejl�c // ';
C_MSG_ADDEVENTCH = 'triggercsatorna (%u) hozz�adva';
C_MSG_PREPEDF = 'EDF bet�lt�s rendben, referencia: %s, eventek: %u';
C_MSG_ADDEVENTCH_EPOCHERR = 'Nem tudok �j csatorn�t hozz�adni, ha m�r epoch-olva van.';
C_MSG_STARTCLEANUP = 'Cleanup started...';
C_MSG_STARTCONDENSING = 'Condensing logfiles...';
C_MSG_STARTCONDENSINGDONE = 'Done';
C_MSG_STARTMUTEXRELEASE = 'Releasing all mutexes...';
C_MSG_STARTMUTEXRELEASEDONE = 'Done';
C_MSG_ENDCLEANUP = 'End cleanup';

C_MSG_AUTODROPCOMP_FORMATERR_WARN = 'Vigy�zat! Hib�s form�tum� adat az "%s" automatiz�l�-f�jl %u. sor�ban: %s!';
C_MSG_AUTODROPCOMP_TABERR_WARN = 'Vigy�zat! T�l kev�s oszlop az "%s" automatiz�l�-f�jl %u. sor�ban!';
C_MSG_AUTODROPCOMP_TOOMUCHWARN = 'Tov�bbi hib�k is voltak, ezeket m�r nem list�zzuk.';
C_MSG_AUTODROPCOMP_FILEERR = 'F�jl I/O hiba: f�jl %s, �zenet %s';
C_MSG_AUTODROPCOMP_AMBIRESULT_WARN = 'Vigy�zat! T�bb bejegyz�s is tartozik %s-hez. Az utols�t v�lasztom.';

C_MSG_AUTODROPCOMP_NOTFOUND = 'Nem tartozik bejegyz�s az adatf�jlhoz, az AUTO_DROPCOMP �gy nem tud futni!';
C_MSG_AUTODROPCOMP_NTD = 'Bejegyz�s a(z) %u. sorban, nincs elt�vol�tand� komponens';
C_MSG_AUTODROPCOMP_COMPNOTFOUND = 'Hiba! Bejegyz�s a(z) %u. sorban, %u elt�vol�tand� komponens, azonban az %s egy�tthat�inak nincs megfelel� komponens (min. t�vols�gok: %s)!';
C_MSG_AUTODROPCOMP_DONE = 'Bejegyz�s a(z) %u. sorban, %u elt�vol�tand� komponens, rendben elt�vol�tva (euklideszi t�vols�gok: %s)';
C_MSG_AUTODROPCOMP_ERRORCONVERTING = 'Bejegyz�s a(z) %u. sorban, hiba az adatok konvert�l�sakor: %s';
C_MSG_AUTODROPCOMP_DIMMISMATCH = 'Bejegyz�s a(z) %u. sorban, viszont a dimenzi�ja (%u) nem egyezik meg az adatok dimenzi�j�val (%u)!';
C_DISP_AUTODROPCOMP_FOUNDCOMP = 'Found component %u->%u, distance %f, max: %f\n';

C_MSG_AUTODROPEPOCH_FORMATERR_WARN = C_MSG_AUTODROPCOMP_FORMATERR_WARN;
C_MSG_AUTODROPEPOCH_TABERR_WARN = C_MSG_AUTODROPCOMP_TABERR_WARN;
C_MSG_AUTODROPEPOCH_TOOMUCHWARN = C_MSG_AUTODROPCOMP_TOOMUCHWARN;
C_MSG_AUTODROPEPOCH_FILEERR = C_MSG_AUTODROPCOMP_FILEERR;
C_MSG_AUTODROPEPOCH_AMBIRESULT_WARN = C_MSG_AUTODROPCOMP_AMBIRESULT_WARN;

C_MSG_AUTODROPEPOCH_NOTFOUND = 'Nem tartozik bejegyz�s az adatf�jlhoz, az AUTO_DROPEPOCH �gy nem tud futni!';
C_MSG_AUTODROPEPOCH_NTD = 'Bejegyz�s a(z) %u. sorban, nincsenek megjel�lend� epochok';
C_MSG_AUTODROPEPOCH_ERRORCONVERTING = C_MSG_AUTODROPCOMP_ERRORCONVERTING;
C_MSG_AUTODROPEPOCH_BOUNDSERR = 'Bejegyz�s a(z) %u. sorban, de az egyik jel�lend� epoch-index t�l nagy/kicsi: %i';
C_MSG_AUTODROPEPOCH_DONE = 'Bejegyz�s a(z) %u. sorban, megjel�lve %u epoch';

C_DI_SETTINGS = 'Be�ll�t�sok';
C_DI_MESSAGES = '�zenetek';
C_DI_OPDIR = 'Feldolgozand� k�nyvt�r:';
C_DI_OR = 'vagy';
C_DI_ICHOOSE = 'magam v�lasztom ki a f�jlokat';

C_MSG_FILESFOUND = '%u f�jlt tal�ltam';
C_MSG_FILESCHOSEN = C_MSG_FILESFOUND;
C_MSG_FILESNOTCHOSEN = '';
C_MSG_SEARCHING = 'Bet�lt�s... %u/%u (%u/%u)';
C_MSG_MUTEXHOLD = 'Mutexek lefoglal�sa...';

C_MSG_AUTOSELECT_ACTIVE = 'AUTO_SELECT opci� akt�v -> %s munkak�nyvt�r kiv�lasztva';
C_MSG_AUTORUN_ACTIVE = 'AUTO_RUN opci� akt�v -> futtat�s';

C_DI_POPUPDIR = 'Add meg a feldolgozand� k�nyvt�rat';
C_DI_POPUPFILE = 'V�laszd ki a feldolgozand� f�jlokat';
C_DI_LOGTOFILE = 'Napl�z�s f�jlba';
C_DI_START = 'Mehet';
C_DI_USERONLY = 'Csak k�zi';
C_DI_STOP = 'STOP';
C_DI_AUTOMODE = 'AUTO �zemm�d';
C_DI_TIMER = 'Id�z�t�';
C_DI_UNTILTHIS = '-ig dolgozhat';
C_DI_COOLDOWN = 'Id�nk�nt pihi';
C_DI_NETWORKMODE = 'H�l�zati m�d';
C_DI_WEEKENDRUN = '�s h�tv�g�n';
C_DI_ETA_RESET = 'nnn/nnn --:--:--';
C_DI_ETA_FORMAT = '%03u/%03u %02u:%02u:%02u';

C_DI_OPTPERCENT = 'Optimum %:';
C_DI_OPTPERCENT_AUTO = 'Auto';
C_DI_COMMONPLUGINS = 'K�z�s plugin k�nyvt�r (ha van):';
C_DI_OPTABLE_EDITOR = 'OP-t�bla-szerk';
C_DI_PLUGIN_EDITOR = 'Plugin-szerk';
C_DI_SAVE_SETTINGS = 'Be�ll.ment';
C_DI_RESTART = 'Restart';
C_DI_CLEANUP = 'CLEANUP';
C_DI_SHOW_COMPUTERS = 'Dolgoz� g�pek';

C_DI_OPTABLEEDITOR_CAPTION = 'EEGbatch OP-t�bla-szerkeszt�';
C_DI_OEDITOR = '-';

C_MSG_PRJLABEL = 'Projekt: %s';
C_MSG_SUBJGRLABEL = 'Alanycsoport: %s';
C_DI_EOP_UNDO = 'VISSZAVON';
C_DI_EOP_SAVE = 'MENT�S';
C_DI_EOP_FIRST = '<<';
C_DI_EOP_LEFT = '<';
C_DI_EOP_RIGHT = '>';
C_DI_EOP_LAST = '>>';
C_DI_EOP_NEW = '�J';
C_DI_EOP_REVERT = 'VISSZA�LL';
C_DI_EOP_SAVEAS = 'MENT�S...';
C_DI_EOP_LOADING = 'T�LT�S...';
C_DI_EOP_SAVING = 'MENT�S...';
C_DI_EOP_IDLE = '';
C_DI_EOP_N_OF_M = 'OP-t�bla: %u/%u';

C_MSG_OPTABLECHANGED_Q = 'M�dos�tottad az OP-t�bl�t. Mented a v�ltoztat�sokat?';
C_MSG_OPTABLECHANGED_TITLE = 'K�rd�s';
C_MSG_OPTABLECHANGED_SAVE = 'Ment�s';
C_MSG_OPTABLECHANGED_SAVEAS = 'Ment�s m�sk�nt...';
C_MSG_OPTABLECHANGED_REJECT = 'Elvet�s';
C_MSG_OPTABLECHANGED_CANCEL = 'M�gsem';

C_MSG_OPTABLECHANGED_SAVE_ERR_Q = 'A ment�s nem siker�lt. Pr�b�lod m�s n�ven?';
C_MSG_OPTABLECHANGED_SAVE_ERR_TITLE = 'K�rd�s';
C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE = 'Add meg az �j f�jlt';
C_MSG_OPTABLE_NEWFILE = C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE;

C_MSG_PE_ERRORSAVING = 'Hiba t�rt�nt a plugin ment�se k�zben:';
C_MSG_PE_ERRORSAVING_Title = 'Hiba!';
C_MSG_PE_CANNOTSAVEEMPTYNAME = 'Nem adt�l meg plugin-nevet!';
C_MSG_OC_CANNOTSAVEEMPTYPRJ = 'Nem adt�l meg projekt-nevet!';
C_MSG_OC_ERRORSAVING_TITLE = 'Hiba!';
C_MSG_EOP_ERRORSAVING = 'Hiba t�rt�nt az OP-t�bla ment�se k�zben:';
C_MSG_EOP_ERRORSAVING_TITLE = 'Hiba!';
C_MSG_DIRNOTFOUND = 'Nem l�tez� munkak�nyvt�r!';
C_MSG_DIRNOTFOUND_TITLE = 'Hiba!';
C_MSG_CANNOT_AUTOMATE_BYFILES = 'Auto �zemm�d csak k�nyvt�r v�laszt�sakor el�rhet�';
C_MSG_CANNOT_AUTOMATE_BYFILES_TITLE = 'Hiba!';
C_MSG_NOWORKDIR = 'Nem adt�l meg munkak�nyvt�rat. Ez a funkci� csak �rv�nyes munkak�nyvt�rral el�rhet�.';
C_MSG_NOWORKDIR_TITLE = 'Hiba!';

C_DI_OC_OCREATOR = 'OP-t�bla-k�sz�t�';
C_DI_OC_PRJ = 'Projekt:';
C_DI_OC_SUBJGR = 'Alanycsop.:';

C_DI_OC_STD19 = 'PREP19';
C_DI_OC_STD64 = 'PREP64';
C_DI_OC_OWN = 'saj�t';
C_DI_OC_NONE = 'dataset';
C_DI_OC_ADD_EVENT_CHANNEL = '�j eventcsatorna';
C_DI_OC_ADD_EVENT_CHANNEL_AUTO = 'Csatornasz�m auto';
C_DI_OC_EVENTS = 'Eventek l�trehoz�sa';
C_DI_OC_EVENT_CHANNEL_AUTO = 'Csatornasz�m auto';
C_DI_OC_POP_IMPORT = 'Import�l�s t�pusa:';
C_DI_OC_FILES = 'Kezd�f�jl:';
C_DI_OC_PHASE = 'Kezd�f�zis:';
C_DI_EOP_UNSAVED = '<unsaved>';
C_DI_OC_EVENT_STEP = 'l�p�sk�z';
C_DI_OC_SAMPLING_RATE = 'mintav�teli frek.';
C_DI_OC_CHAN_LOCS = 'csatornainf�:';
C_DI_OC_HIGHPASS = 'als�sz�r�'; % ezek a magyarban ford�tva vannak
C_DI_OC_LOWPASS = 'fels�sz�r�';
C_DI_OC_EPOCH = 'Epochokra bont�s';
C_DI_OC_EPOCH_AUTO = 'auto hat�rok';
C_DI_OC_EPOCH_LIMITS = 'hat�rok:';
C_DI_OC_BASELINE = 'Baseline-elt�vol�t�s';
C_DI_OC_BASELINE_ALL = 'teljes';
C_DI_OC_BASELINE_LIMITS = 'hat�rok';
C_DI_OC_THRESH = 'K�sz�bvizsg�lat';
C_DI_OC_THRESH_LIMITS = 'hat�rok';
C_DI_OC_DROPEPOCH = 'K�zi epochvizsg�lat';
C_DI_OC_ICA = 'ICA futtat�sa';
C_DI_OC_DROPCOMP = 'K�zi komponenselt�vol�t�s';
C_DI_OC_SETTINGS = 'BE�LL�T�SOK';
C_DI_OC_RESULT = 'EREDM�NY';
C_DI_OC_SAVE = 'MENT�S';

C_MSG_LETS_GO = 'ezeket hajtod v�gre, ha megnyomod a %s vagy a %s gombot';
C_MSG_BYFILES_ENDED = 'A k�zi v�laszt�s� �zemm�d v�gzett, �j m�velet ind�t�s�hoz v�lasszon ki �j f�jlokat!';
C_MSG_NOPE = 'nincs v�grehajthat� feladat';

C_MSG_IDLE = 'T�TLEN';
C_MSG_RUN = 'fut�s';
C_MSG_AUTORUN = 'fut�s a h�tt�rben'; 
C_MSG_USERONLY = 'csak a k�zi m�d�ak futtat�sa';
C_MSG_STOPPING = 'az aktu�lis m�velet ut�n le�ll';
C_MSG_INIT = 'INIT';
C_MSG_USERMODE_SKIPPED = '(a felhaszn�l�i beavatkoz�st ig�nyl�ek nem futottak)';
C_MSG_AUTOMODE_SKIPPED = '(az automata m�d�ak nem futottak)';
C_MSG_CANCELLED_TASK = 'NEM FUTOTT';
C_MSG_CANCELLED_MAINMSG = 'felhaszn�l�i megszak�t�s, nem minden futott le';
C_MSG_ALLDONE = 'minden lefutott (%04u/%02u/%02u-%02u:%02u:%02u)';
C_MSG_OPTABLES_LOADED = '(beolvasva %u op.t�bla)';
C_MSG_TIMER_HLT = 'Feldolgoz�s meg�ll�tva %u:%u:%u-ig';
C_MSG_TIMER_REST = '%u:%u:%u-et �t�tt m�r az �ra, feldolgoz�s folytat�sa';
C_MSG_COOLDOWN_HLT = 'Feldolgoz�s felf�ggesztve %u:%u:%u id�re';
C_MSG_COOLDOWN_REST = '%u:%u:%u -- feldolgoz�s folytat�sa';
C_MSG_SEARCH_HLT = 'V�rakoz�s �jabb feladatokra %u:%u:%u ideig';

C_MSG_INCREASINGDITABLE = 'DITable m�rete megn�velve: %u -> %u';
C_MSG_SEARCHDATSETSMULTIDIR = 'T�bb k�l�nb�z� k�nyvt�rb�l nem tudok dolgozni (%s,%s)!';
C_MSG_INVALIDFILENAME1 = 'P�ratlan ''['' vagy '']'' a f�jln�vben: %s. Nem �rtem.';
C_MSG_INVALIDFILENAME2 = 'T�l sok (t�bb, mint kett�) ''[...]'' szekci� a f�jln�vben: %s. Nem �rtem.';
C_MSG_INTERNAL_POSTFIX = ' --> Furcsa hiba.';
C_MSG_CANNOT_PACK_FN_NO_SUBJECT = ['A PackFilename() nem kapott subjectet. (%s;%s;%s;%s;%s;%s;%s)' C_MSG_INTERNAL_POSTFIX];
C_MSG_CANNOT_PACK_SN_NO_SUBJECT = ['A PackSetname() nem kapott subjectet. (%s;%s;%s;%s;%s;%s;%s)' C_MSG_INTERNAL_POSTFIX];
C_MSG_ERRORCHK = 'Hiba a %s plugin ellen�rz� v�grehajt�sakor: %s';
C_MSG_EXCEPTION_ONLY_CODE = '(hibak�d: %u)';
C_MSG_NOPLUGIN_WARNING = 'Vigy�zat! Bizonyos pluginek hi�nyoznak, ezeket kihagyjuk.';
C_MSG_MULTI_WARNING = 'Vigy�zat! Egyszerre akar kezelni dataseteket olyan pluginekkel, amelyek erre nem alkalmasak! Ez nem fog futni.';
C_MSG_NOPLUGIN_ERROR = 'HIBA! A k�vetkez� plugint nem tal�lom: %s';
C_MSG_MULTI_ERROR = 'HIBA! Egyszerre akar kezelni t�bb datasetet, ez a plugin nem alkalmas r�: %s';
C_MSG_THIS_USERMODE_SKIPPED = '--k�zi m�d�--';
C_MSG_THIS_AUTOMODE_SKIPPED = '--auto m�d�--';
C_MSG_THIS_DONE = '(kor�bban m�r elk�sz�lt)';
C_MSG_THIS_NOPLUGIN = '(ERR: nem tal�lom a plugint)';
C_MSG_THIS_ERRORCHK = '(ERR: hiba ellen�rz�s k�zben)';
C_MSG_THIS_ERRORRUN = '(ERR: hiba (kor�bban) fut�s k�zben)';
C_MSG_THIS_MULTIERROR = '(ERR: ez a plugin nem tud t�bb datasettel dolgozni)';
C_MSG_THIS_MUTEXERROR = '(mutex: m�s csin�lja �ppen)';
C_MSG_THIS_EXOTIC = 'EXOTIKUS hibak�d: %u';
C_MSG_THIS_OPTMANAGEMENT = 'K�S�BBre halasztva';

C_MSG_PLUGIN_CANNOT_SELFCHECK = 'Ez a plugin nem k�pes �nellen�z�sre! (Val�sz�n�leg az OP-t�bl�ban nincs kit�ltve a megfelel� sor kimeneti mez�je vagy m�shogy szab�lytalan.)'; % v0.1.022 (�tfogalmaz�s)
C_MSG_NOPATHBUTFILES = 'Nem tudjuk meghat�rozni a kiv�lasztott f�jlok �tvonal�t. Pr�b�lja nem f�jlonk�nt!'; % v0.2.003 - C_MSG_INTERNAL_POSTFIX removed from the following lines
C_MSG_FSMUTEX_NOCREATE = 'Mutex (%s) nem j�tt l�tre!'; % v0.1.016
C_MSG_FSMUTEX_NOTEXIST = 'Mutex (%s) nem l�tezett!';
C_MSG_FSMUTEX_NODELETE = 'A mutexet (%s) nem siker�lt t�r�lni!';
C_MSG_FSMUTEX_NOCREATE2 = 'A mutexet (%s) nem lehetett megnyitni/l�trehozni!';
C_MSG_FSMUTEX_NOOWNER = 'A mutexnek (%s) �gy t�nik, nincs gazd�ja!';
C_MSG_FSMUTEX_DIFFOWNER = 'A mutexet (%s) �pp felszabad�tjuk, de kider�lt, hogy m�s hozta l�tre: %s';

C_MSG_MTXCLEARED = '%u kor�bbi �rv�n maradt mutexet t�r�ltem';
C_MSG_MTXCLEARED2 = 'Figyelem! Elt�vol�tva �sszesen %u �rva mutex. A k�vetkez� g�peken �sszeoml�s t�rt�nhetett: %s';

C_MSG_FLOGREINIT = 'Hiba t�rt�nt kor�bban a f�jlnapl�z�s sor�n. Megpr�b�ljuk �jra.';
C_MSG_ELOGREINIT = 'Hiba t�rt�nt kor�bban a hibanapl� kezel�se sor�n. Megpr�b�ljuk �jra.';
C_MSG_XLOGREINIT = 'Hiba t�rt�nt kor�bban a debugnapl� kezel�se sor�n. Megpr�b�ljuk �jra.';
C_MSG_NEWLOGFILE = 'Napl�f�jl: %s';
C_MSG_CANNOTCONDENSE = 'Hiba a kor�bbi logf�jlok t�m�r�t�se k�zben: %s (f�jl: %s)';

C_MSG_FILELOGERROR = 'Napl�f�jl (%s) megnyit�si/�r�si hiba: %s. F�jlba napol�z�s ideiglenesen kikapcsolva.';
C_MSG_ERRORLOGERROR = 'Hibanapl� (%s) megnyit�si/�r�si hiba: %s. K�l�n hibanapl�z�s ideiglenesen kikapcsolva.';
C_MSG_XLOGERROR = 'Debuglog (%s) megnyit�si/�r�si hiba: %s. Debugnapl� egy id�re kikapcsolva.';
C_MSG_XLOGEXCEPTION = 'Debuglog hiba: %s. Debugnapl� egy id�re kikapcsolva.\n';
C_MSG_OPTABLEIOERR = 'OPt�bla (%s) megnyit�si/olvas�si hiba: %s. OPt�bla kihagyva.';
C_MSG_OPTABLEERR = 'Struktur�lis hiba: nincs meg legal�bb 5 oszlop';

C_MSG_DSETLOGLINE1MEM = 'MATLAB uses %u MiB\t\tMax array %u MiB\t\tPhys avail %u MiB\t\t%u files opened';
C_MSG_DSETLOGLINE1NOMEM = '';	% fix(clock) % v0.1.019 - felesleges id�pecs�t elt�ntetve
C_MSG_DSETLOGLINE1B_UNMEASURABLE = 'Plugin time unmeasurable';
C_MSG_DSETLOGLINE1B = 'Plugin time %u:%.2f\t\t%.2f epochs/sec\t\t%.2f samples/sec';
C_MSG_DSETLOGLINE2 = '%s ----> %s ----> %s';	% infile,Func,outfile
C_MSG_DSETLOGLINE3S = 'param�terek: %s';	% params
C_MSG_DSETLOGLINE3M = 'param�terek: %s, egy�tt: %s';	% params,condslist
C_MSG_DSETLOGLINE3E = 'param�terek: %s, HIBA: %s';	% params,error
C_MSG_DSETLOGLINE4 = '-----------------';

C_MSG_VLOGADD = 'K�SZ (k�d:%u) (%04u/%02u/%02u-%02u:%02u:%02u)';	% error, fix(clock)
C_MSG_LISTDITABLE_NOINFILE = ['�res ''infile'' mez� az OPt�bl�ban!' C_MSG_INTERNAL_POSTFIX];
C_MSG_LISTDITABLE_INTERNAL_OUTPHASE = '<INTERNAL>';
C_MSG_PATHADDED = 'added to path: %s';

C_DISP_MAINWNDCLOSING = 'EEGbatch: f�ablak lez�r�sa';
C_DISP_EEGBATCHRESTART = 'EEGbatch: restart';

C_DISP_SETTINGSLOADED = 'Be�ll�t�sok bet�ltve %s f�jlb�l\n';
C_DISP_SETTINGSSAVED = 'Be�ll�t�sok mentve (%s)\n';
C_MSG_LOADSETERR = 'Hiba a be�ll�t�sok bet�lt�se k�zben (f�jl: %s, hiba: %s)';
C_MSG_LOADSETERR2 = 'Hiba a be�ll�t�sok bet�lt�se k�zben: %s';
C_MSG_SAVESETERR = 'Hiba a be�ll�t�sok ment�se k�zben (f�jl: %s, hiba: %s)';
C_MSG_SAVESETERR2 = 'Hiba a be�ll�t�sok bet�lt�se k�zben: %s'; 

C_MSG_FREQINROW_NOBANDFILE = 'DO_freqinrow: A bandsetupfile (%s) nem l�tezik? (hiba�zenet: %s)';
C_MSG_FREQINROW_NOCHANLOCS = 'Nem tudok anterior-posterior/bal-jobb elemz�st csin�lni, nincs channel locations megadva! ';
C_MSG_FREQINROW_FILEERR1 = 'DO_freqinrow: Az spss header/output f�jl (%s) megnyit�sa k�zben a k�vetkez� hib�t jelezte a rendszer: %s';
C_MSG_FREQINROW_FILEERR2 = 'DO_freqinrow: Az spss output f�jl (%s) megnyit�sa k�zben a k�vetkez� hib�t jelezte a rendszer: %s';
C_MSG_FREQINROW_CHANNELERR = 'DO_freqinrow: a spectopo() nem szab�lyos csatorn�t tal�lt. Tal�n bennmaradt egy signalcsatorna?';
C_MSG_FREQINROW_EMPTYBAND = 'DO_freqinrow: a spectopo() nem tal�lt %s tartom�nyba (%.1f-%.1f) es� hull�mot!';
C_MSG_FREQINROW = '%ux%u CSV-t�bla ki�rva %s f�jlba';
C_DISP_FREQINROW_ANTEPOSTE = 'Ante/poste/left/right: %u/%u/%u/%u, pontosabban: ante: %s, poste: %s, left: %s, right: %s\n';
C_DISP_FREQINROW_PROCESSING = '%u/%u epoch feldolgoz�sa (f�jl ETA: %02u:%02u:%02u)...\n';
C_DISP_FREQINROW_DONE = '%ux%u CSV-t�bla ki�rva %s f�jlba\n';

C_MSG_FREQINROW_HEADER_PRJ = 'projekt';
C_MSG_FREQINROW_HEADER_SUBJ = 'azonosito';
C_MSG_FREQINROW_HEADER_SUBJGR = 'csoport';
C_MSG_FREQINROW_HEADER_COND = 'feltetel';
C_MSG_FREQINROW_HEADER_EPOCHCOUNT = 'epochszam';
C_MSG_FREQINROW_HEADER_EPOCHNR = 'sorszam';
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

C_MSG_SELECT = 'pop_select() lefutott, EEGdata m�rete: ';


C_MSG_PERFINDEXMUTEXERROR = 'Nem tudom el�rni a %s f�jlt, m�s folyamat haszn�lja �ppen (hossz� id�n kereszt�l tart� mutex error). �rva mutex lehet? Esetleg egy cleanup seg�tene?'; 
C_MSG_ERRORLOGMUTEXERROR = 'Nem tudom el�rni a %s f�jlt, m�s folyamat haszn�lja �ppen (hossz� id�n kereszt�l tart� mutex error). �rva mutex lehet? Esetleg egy cleanup seg�tene?'; 
C_MSG_XLOGMUTEXERROR = 'Nem tudom el�rni a %s f�jlt, m�s folyamat haszn�lja �ppen (hossz� id�n kereszt�l tart� mutex error). �rva mutex lehet? Esetleg egy cleanup seg�tene?'; 
C_MSG_CALCULATING_PI = 'PIndex kisz�m�t�sa...';
C_MSG_GOT_PI = 'Optimaliz�lt sz�zal�k: %u, PIndex: %u (MF:%u), %u elem a PIndex-t�bl�ban';
C_MSG_PI_OVR = 'Optimaliz�lt sz�zal�k: %u (k�zi be�ll�t�s)';

C_MSG_INTERRORSD = ['LE�LLT: v�ratlan hiba t�rt�nt a feladatok felkutat�sa k�zben: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_INTERRORPR = ['LE�LLT: v�ratlan hiba t�rt�nt a feladatok v�grehajt�sa k�zben: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_INTERRORLDI = ['LE�LLT: v�ratlan hiba t�rt�nt a feladatok list�z�sa k�zben: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_ERRORSD = 'LE�LLT: hiba a feladatok felkutat�sakor: %s';
C_MSG_ERRORPR = 'LE�LLT: hiba a feladatok v�grehajt�sakor: %s';

C_DI_PLUGINEDITOR_CAPTION = 'EEGbatch Plugin-szerkeszt�';
C_DI_PLUGINEDITOR_PLUGINNAME = 'plugin neve:';
C_DI_PLUGINEDITOR_PLUGINPARAMS = 'param�terek:';
C_DI_PLUGINEDITOR_SAVE = 'MENT�S';
C_DI_PLUGINEDITOR_FUNCTIONFORMAT = 'function [funcres, EEG, logstr] = %s(dataset,EEG,wtd%s)';
C_DI_HELP1 = { ...
    'N�mi seg�ts�g:', ...
    '', ...
    'dataset.FN........f�jln�v', ...
    'dataset.Prj.......projektn�v', ...
    'dataset.SubjGr....alanycsoport', ...
    'dataset.Subj......alany', ...
    'dataset.Cond......kond�ci�', ...
    '(ha t�bb datasetet is kaphat,', ...
    'akkor dataset(i).FN stb.)'};

C_DI_HELP2 = { ...
    'EEG..........nyilv�n', ...
    'wtd..........''run'' vagy ''check'' (ut�bbit csak akkor kell implement�lni, ha a plugin maga ellen�rzi, hogy lefutott-e m�r)', ...
    'funcres.......ebben adjuk vissza a st�tuszt, <0: hiba t�rt�nt, >0: t�j�koztat�'};

C_DI_PE_BODY = {'% innent�l kezd�dik a plugin k�dja', ...
		'if strcmpi(wtd,''run'')', ...
		'% csak, ha wtd == ''run''', ...
		 '', ...
		'    % a t�nyleges k�d', ...
		'', ...
		'end;'};

C_DI_PE_POSTFIX = 'end';
