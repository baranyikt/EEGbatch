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
%                                  Hungarian translation      %
%                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ! Note: this is not an .m file to be called separately, you should 
% rather replace the main file's "TRANSLATE" part to the one in this
% in order to switch all EEGbatch messages to hungarian.

% ! Megjegyzés: ez nem önmagában futtatandó .m fájl, használata:
% a "TRANSLATE" részt kell kicserélni erre a fo futtatható fájlban.

%
%
%
% ----------------- TRANSLATE ---------------------
%
%
%
C_MSG_NOEEGLAB_ERR = 'HIBA: EEGLAB nincs betöltve. Elõbb indítsd el az EEGLAB-ot! \nAz EEGbatch most kilép.\n';
C_MSG_VLOGCLC = 'A képernyõlog elérte a %u sort, újrakezdtük. (A fájllog és a többi érintetlen.)';
C_MSG_OPT_RATIO_INFOLINE1 = '[opt_ratio: ON  opt_ratio_planned %u opt_ratio_all %u opt_ratio_skipped %u opt_ratio_mutexed %u]';
C_MSG_OPT_RATIO_INFOLINE2 = '[opt_ratio: OFF opt_ratio_planned %u opt_ratio_all %u opt_ratio_skipped %u opt_ratio_mutexed %u]';
C_MSG_PI_MTX_WAITING = 'Várakozás míg %s elérhetõ lesz (max %u másodpercig)...';
C_MSG_ELOG_MTX_WAITING = 'Várakozás míg %s elérhetõ lesz (max %u másodpercig)...';
C_MSG_XLOG_MTX_WAITING = 'Várakozás míg %s elérhetõ lesz (max %u másodpercig)...';
C_MSG_OPTABLECHANGED_EXTTYPES = {'*.txt','Text files (*.txt)';'*.*','All files (*.*)'};
C_MSG_DROPCOMP_Q = 'A jelenlegi fázisban kérlek, válaszd ki az EEGLAB Tools menüjébõl a Reject data using ICA, azon belül a Reject components by map menüpontot! Ha ezzel végeztél, akkor pedig ugyancsak a Tools menü Remove components menüpontját, végül nyomd meg az OK gombot.';
C_MSG_DROPCOMP_TITLE = '%s';
C_MSG_DROPCOMP_Q_PRTSCR = 'A jelenlegi fázisban kérlek, válaszd ki az EEGLAB Tools menüjébõl a Reject data using ICA, azon belül a Reject components by map menüpontot! Ha ezzel végeztél, fotózd le a PrtScr (Print Screen) gombbal, majd pedig ugyancsak a Tools menü Remove components menüpontját, végül nyomd meg az OK gombot.';
C_MSG_DROPCOMP_TITLE_PRTSCR = '%s';
C_MSG_DROPCOMP_OK = 'OK';
C_MSG_DROPCOMP_CANCEL = 'Ne mentsd';
C_MSG_DROPCOMP_STOP = 'Ne és ÁLLJ!';
C_MSG_DROPCOMP_AUTOERR = 'DROPCOMP automatizálási hiba %s fájl írásakor (a mûvelet ettõl még sikeres lehet): %s /// ';
C_MSG_DROPEPOCH_EEGL_Q = 'A jelenlegi fázisban kérlek, válaszd ki az EEGLAB Tools menüjébõl a Reject data epochs-t, azon belül a Reject by inspection menüpontot! Ha végeztél, nyomd meg az OK gombot.';
C_MSG_DROPEPOCH_EEGL_Title = '%s';
C_MSG_DROPEPOCH_EEGL_OK = 'OK';
C_MSG_DROPEPOCH_EEGL_CANCEL = 'Ne mentsd';
C_MSG_DROPEPOCH_EEGL_STOP = 'Ne és ÁLLJ!';
C_MSG_DROPEPOCH_AUTOERR = 'DROPEPOCH automatizálási hiba %s fájl írásakor (a mûvelet ettõl még sikeres lehet): %s /// ';
C_MSG_DROPEPOCH_REJSAVEERR = 'DROPEPOCH automatizálási hiba %s fájl írásakor (a mûvelet ettõl még sikeres lehet): %s /// ';
C_DISP_DROPEPOCH_CONNECT = '%s: csatlakozás az EEGLAB-hoz...';
C_DISP_DROPEPOCH_CONNECTED = 'Rendben\nVárakozás a felhasználóra...';
C_DISP_DROPEPOCH_FINISH = 'Rendben, feldolgozás és mentés\n';
C_DISP_DROPEPOCH_INFOLINE = 'Megjelölve %u epoch %u-ból, %.1f %%\n';
C_MSG_LOGFILE_INIT = 'EEGbatch %s@%s indul';
C_MSG_PREP19_INIT = 'Adatfájl elõkészítése';
C_MSG_EVENT = 'létrehozva %u event a %u csatornából';
C_MSG_EPOCH = 'epochok létrehozva (%f-%f, egy event %u pont hosszú)';
C_MSG_EPOCH_ERROR = 'hiba epoch létrehozás közben (%f-%f), az adattömb nem vált szét: %u x %u';
C_MSG_EPOCH_PARAMERROR = 'Ha az DO_EPOCHS két limit-paramétere -1 (mint jelen esetben), akkor a harmadik paraméterben várja az epoch sample-ben megadott kívánt hosszát!';
C_MSG_BASELINE = 'baseline remove (%i;%i)';
C_MSG_HIGHPASS = 'highpass (%f)';
C_MSG_LOWPASS = 'lowpass (%f)';
C_MSG_THRESH = 'gyanús értékek szûrése, csatornák: %u-%u, alsó határ: %u, felsõ határ: %u, eldobott epochok: %s';
C_MSG_DROPEPOCH = 'kézi epoch-eldobás, megjegyzés [%s], a kiválasztott epochok: [%s]'; % v0.1.020
C_MSG_DROPCOMP = 'komponensek eltávolítása, eltávolítva %u komponens, megjegyzés [%s], komponensek együtthatói: %s';
C_MSG_DROPCOMP_PRTSCR = 'komponensek eltávolítása, eltávolítva %u komponens, megjegyzés [%s], képernyõkép-fájl: [%s], komponensek együtthatói: [%s]';
C_DISP_DROPCOMP_OKPRTSCR = 'USER_DROPCOMP: %s kép mentve a vágólapról\n'; % v0.2.002
C_DISP_DROPCOMP_NOPRTSCR = 'USER_DROPCOMP: Nincs kép a vágólapon!\n';
C_MSG_IDROPCOMP_BADPARAM = 'A DO_IDROPCOMP-nak meg kell adni mûtermék-csatornákat! Valószínûleg rosszul formázott az OPtable';
C_MSG_IDROPCOMP_AUTOERR = C_MSG_DROPCOMP_AUTOERR;
C_MSG_IDROPCOMP = 'komponensek mûtermékcsatornán alapuló eltávolítása (IDROPCOMP), eltávolítva %u komponens, mûtermék-csatornák [%s], az eltávolított komponensek érintettsége ezekbõl: %s, a komponensek együtthatói: %s';
C_DISP_THRESH_ALLGONE = 'Vigyázat, a DO_THRESH mindent kiírtott! Túl szigorú feltételek?\n';
C_MSG_ICA = 'ICA [type:%s] [options:%s] [logfile:%s] [conditions:%s]';
C_MSG_PREP19_REJLINES = 'törölve %u sor fejléc // ';
C_MSG_ADDEVENTCH = 'triggercsatorna (%u) hozzáadva';
C_MSG_PREPEDF = 'EDF betöltés rendben, referencia: %s, eventek: %u';
C_MSG_ADDEVENTCH_EPOCHERR = 'Nem tudok új csatornát hozzáadni, ha már epoch-olva van.';
C_MSG_STARTCLEANUP = 'Cleanup started...';
C_MSG_STARTCONDENSING = 'Condensing logfiles...';
C_MSG_STARTCONDENSINGDONE = 'Done';
C_MSG_STARTMUTEXRELEASE = 'Releasing all mutexes...';
C_MSG_STARTMUTEXRELEASEDONE = 'Done';
C_MSG_ENDCLEANUP = 'End cleanup';

C_MSG_AUTODROPCOMP_FORMATERR_WARN = 'Vigyázat! Hibás formátumú adat az "%s" automatizáló-fájl %u. sorában: %s!';
C_MSG_AUTODROPCOMP_TABERR_WARN = 'Vigyázat! Túl kevés oszlop az "%s" automatizáló-fájl %u. sorában!';
C_MSG_AUTODROPCOMP_TOOMUCHWARN = 'További hibák is voltak, ezeket már nem listázzuk.';
C_MSG_AUTODROPCOMP_FILEERR = 'Fájl I/O hiba: fájl %s, üzenet %s';
C_MSG_AUTODROPCOMP_AMBIRESULT_WARN = 'Vigyázat! Több bejegyzés is tartozik %s-hez. Az utolsót választom.';

C_MSG_AUTODROPCOMP_NOTFOUND = 'Nem tartozik bejegyzés az adatfájlhoz, az AUTO_DROPCOMP így nem tud futni!';
C_MSG_AUTODROPCOMP_NTD = 'Bejegyzés a(z) %u. sorban, nincs eltávolítandó komponens';
C_MSG_AUTODROPCOMP_COMPNOTFOUND = 'Hiba! Bejegyzés a(z) %u. sorban, %u eltávolítandó komponens, azonban az %s együtthatóinak nincs megfelelõ komponens (min. távolságok: %s)!';
C_MSG_AUTODROPCOMP_DONE = 'Bejegyzés a(z) %u. sorban, %u eltávolítandó komponens, rendben eltávolítva (euklideszi távolságok: %s)';
C_MSG_AUTODROPCOMP_ERRORCONVERTING = 'Bejegyzés a(z) %u. sorban, hiba az adatok konvertálásakor: %s';
C_MSG_AUTODROPCOMP_DIMMISMATCH = 'Bejegyzés a(z) %u. sorban, viszont a dimenziója (%u) nem egyezik meg az adatok dimenziójával (%u)!';
C_DISP_AUTODROPCOMP_FOUNDCOMP = 'Found component %u->%u, distance %f, max: %f\n';

C_MSG_AUTODROPEPOCH_FORMATERR_WARN = C_MSG_AUTODROPCOMP_FORMATERR_WARN;
C_MSG_AUTODROPEPOCH_TABERR_WARN = C_MSG_AUTODROPCOMP_TABERR_WARN;
C_MSG_AUTODROPEPOCH_TOOMUCHWARN = C_MSG_AUTODROPCOMP_TOOMUCHWARN;
C_MSG_AUTODROPEPOCH_FILEERR = C_MSG_AUTODROPCOMP_FILEERR;
C_MSG_AUTODROPEPOCH_AMBIRESULT_WARN = C_MSG_AUTODROPCOMP_AMBIRESULT_WARN;

C_MSG_AUTODROPEPOCH_NOTFOUND = 'Nem tartozik bejegyzés az adatfájlhoz, az AUTO_DROPEPOCH így nem tud futni!';
C_MSG_AUTODROPEPOCH_NTD = 'Bejegyzés a(z) %u. sorban, nincsenek megjelölendõ epochok';
C_MSG_AUTODROPEPOCH_ERRORCONVERTING = C_MSG_AUTODROPCOMP_ERRORCONVERTING;
C_MSG_AUTODROPEPOCH_BOUNDSERR = 'Bejegyzés a(z) %u. sorban, de az egyik jelölendõ epoch-index túl nagy/kicsi: %i';
C_MSG_AUTODROPEPOCH_DONE = 'Bejegyzés a(z) %u. sorban, megjelölve %u epoch';

C_DI_SETTINGS = 'Beállítások';
C_DI_MESSAGES = 'Üzenetek';
C_DI_OPDIR = 'Feldolgozandó könyvtár:';
C_DI_OR = 'vagy';
C_DI_ICHOOSE = 'magam választom ki a fájlokat';

C_MSG_FILESFOUND = '%u fájlt találtam';
C_MSG_FILESCHOSEN = C_MSG_FILESFOUND;
C_MSG_FILESNOTCHOSEN = '';
C_MSG_SEARCHING = 'Betöltés... %u/%u (%u/%u)';
C_MSG_MUTEXHOLD = 'Mutexek lefoglalása...';

C_MSG_AUTOSELECT_ACTIVE = 'AUTO_SELECT opció aktív -> %s munkakönyvtár kiválasztva';
C_MSG_AUTORUN_ACTIVE = 'AUTO_RUN opció aktív -> futtatás';

C_DI_POPUPDIR = 'Add meg a feldolgozandó könyvtárat';
C_DI_POPUPFILE = 'Válaszd ki a feldolgozandó fájlokat';
C_DI_LOGTOFILE = 'Naplózás fájlba';
C_DI_START = 'Mehet';
C_DI_USERONLY = 'Csak kézi';
C_DI_STOP = 'STOP';
C_DI_AUTOMODE = 'AUTO üzemmód';
C_DI_TIMER = 'Idõzítõ';
C_DI_UNTILTHIS = '-ig dolgozhat';
C_DI_COOLDOWN = 'Idõnként pihi';
C_DI_NETWORKMODE = 'Hálózati mód';
C_DI_WEEKENDRUN = 'és hétvégén';
C_DI_ETA_RESET = 'nnn/nnn --:--:--';
C_DI_ETA_FORMAT = '%03u/%03u %02u:%02u:%02u';

C_DI_OPTPERCENT = 'Optimum %:';
C_DI_OPTPERCENT_AUTO = 'Auto';
C_DI_COMMONPLUGINS = 'Közös plugin könyvtár (ha van):';
C_DI_OPTABLE_EDITOR = 'OP-tábla-szerk';
C_DI_PLUGIN_EDITOR = 'Plugin-szerk';
C_DI_SAVE_SETTINGS = 'Beáll.ment';
C_DI_RESTART = 'Restart';
C_DI_CLEANUP = 'CLEANUP';
C_DI_SHOW_COMPUTERS = 'Dolgozó gépek';

C_DI_OPTABLEEDITOR_CAPTION = 'EEGbatch OP-tábla-szerkesztõ';
C_DI_OEDITOR = '-';

C_MSG_PRJLABEL = 'Projekt: %s';
C_MSG_SUBJGRLABEL = 'Alanycsoport: %s';
C_DI_EOP_UNDO = 'VISSZAVON';
C_DI_EOP_SAVE = 'MENTÉS';
C_DI_EOP_FIRST = '<<';
C_DI_EOP_LEFT = '<';
C_DI_EOP_RIGHT = '>';
C_DI_EOP_LAST = '>>';
C_DI_EOP_NEW = 'ÚJ';
C_DI_EOP_REVERT = 'VISSZAÁLL';
C_DI_EOP_SAVEAS = 'MENTÉS...';
C_DI_EOP_LOADING = 'TÖLTÉS...';
C_DI_EOP_SAVING = 'MENTÉS...';
C_DI_EOP_IDLE = '';
C_DI_EOP_N_OF_M = 'OP-tábla: %u/%u';

C_MSG_OPTABLECHANGED_Q = 'Módosítottad az OP-táblát. Mented a változtatásokat?';
C_MSG_OPTABLECHANGED_TITLE = 'Kérdés';
C_MSG_OPTABLECHANGED_SAVE = 'Mentés';
C_MSG_OPTABLECHANGED_SAVEAS = 'Mentés másként...';
C_MSG_OPTABLECHANGED_REJECT = 'Elvetés';
C_MSG_OPTABLECHANGED_CANCEL = 'Mégsem';

C_MSG_OPTABLECHANGED_SAVE_ERR_Q = 'A mentés nem sikerült. Próbálod más néven?';
C_MSG_OPTABLECHANGED_SAVE_ERR_TITLE = 'Kérdés';
C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE = 'Add meg az új fájlt';
C_MSG_OPTABLE_NEWFILE = C_MSG_OPTABLECHANGED_SAVE_ERR_NEWFILE;

C_MSG_PE_ERRORSAVING = 'Hiba történt a plugin mentése közben:';
C_MSG_PE_ERRORSAVING_Title = 'Hiba!';
C_MSG_PE_CANNOTSAVEEMPTYNAME = 'Nem adtál meg plugin-nevet!';
C_MSG_OC_CANNOTSAVEEMPTYPRJ = 'Nem adtál meg projekt-nevet!';
C_MSG_OC_ERRORSAVING_TITLE = 'Hiba!';
C_MSG_EOP_ERRORSAVING = 'Hiba történt az OP-tábla mentése közben:';
C_MSG_EOP_ERRORSAVING_TITLE = 'Hiba!';
C_MSG_DIRNOTFOUND = 'Nem létezõ munkakönyvtár!';
C_MSG_DIRNOTFOUND_TITLE = 'Hiba!';
C_MSG_CANNOT_AUTOMATE_BYFILES = 'Auto üzemmód csak könyvtár választásakor elérhetõ';
C_MSG_CANNOT_AUTOMATE_BYFILES_TITLE = 'Hiba!';
C_MSG_NOWORKDIR = 'Nem adtál meg munkakönyvtárat. Ez a funkció csak érvényes munkakönyvtárral elérhetõ.';
C_MSG_NOWORKDIR_TITLE = 'Hiba!';

C_DI_OC_OCREATOR = 'OP-tábla-készítõ';
C_DI_OC_PRJ = 'Projekt:';
C_DI_OC_SUBJGR = 'Alanycsop.:';

C_DI_OC_STD19 = 'PREP19';
C_DI_OC_STD64 = 'PREP64';
C_DI_OC_OWN = 'saját';
C_DI_OC_NONE = 'dataset';
C_DI_OC_ADD_EVENT_CHANNEL = 'Új eventcsatorna';
C_DI_OC_ADD_EVENT_CHANNEL_AUTO = 'Csatornaszám auto';
C_DI_OC_EVENTS = 'Eventek létrehozása';
C_DI_OC_EVENT_CHANNEL_AUTO = 'Csatornaszám auto';
C_DI_OC_POP_IMPORT = 'Importálás típusa:';
C_DI_OC_FILES = 'Kezdõfájl:';
C_DI_OC_PHASE = 'Kezdõfázis:';
C_DI_EOP_UNSAVED = '<unsaved>';
C_DI_OC_EVENT_STEP = 'lépésköz';
C_DI_OC_SAMPLING_RATE = 'mintavételi frek.';
C_DI_OC_CHAN_LOCS = 'csatornainfó:';
C_DI_OC_HIGHPASS = 'alsószûrõ'; % ezek a magyarban fordítva vannak
C_DI_OC_LOWPASS = 'felsõszûrõ';
C_DI_OC_EPOCH = 'Epochokra bontás';
C_DI_OC_EPOCH_AUTO = 'auto határok';
C_DI_OC_EPOCH_LIMITS = 'határok:';
C_DI_OC_BASELINE = 'Baseline-eltávolítás';
C_DI_OC_BASELINE_ALL = 'teljes';
C_DI_OC_BASELINE_LIMITS = 'határok';
C_DI_OC_THRESH = 'Küszöbvizsgálat';
C_DI_OC_THRESH_LIMITS = 'határok';
C_DI_OC_DROPEPOCH = 'Kézi epochvizsgálat';
C_DI_OC_ICA = 'ICA futtatása';
C_DI_OC_DROPCOMP = 'Kézi komponenseltávolítás';
C_DI_OC_SETTINGS = 'BEÁLLÍTÁSOK';
C_DI_OC_RESULT = 'EREDMÉNY';
C_DI_OC_SAVE = 'MENTÉS';

C_MSG_LETS_GO = 'ezeket hajtod végre, ha megnyomod a %s vagy a %s gombot';
C_MSG_BYFILES_ENDED = 'A kézi választású üzemmód végzett, új mûvelet indításához válasszon ki új fájlokat!';
C_MSG_NOPE = 'nincs végrehajtható feladat';

C_MSG_IDLE = 'TÉTLEN';
C_MSG_RUN = 'futás';
C_MSG_AUTORUN = 'futás a háttérben'; 
C_MSG_USERONLY = 'csak a kézi módúak futtatása';
C_MSG_STOPPING = 'az aktuális mûvelet után leáll';
C_MSG_INIT = 'INIT';
C_MSG_USERMODE_SKIPPED = '(a felhasználói beavatkozást igénylõek nem futottak)';
C_MSG_AUTOMODE_SKIPPED = '(az automata módúak nem futottak)';
C_MSG_CANCELLED_TASK = 'NEM FUTOTT';
C_MSG_CANCELLED_MAINMSG = 'felhasználói megszakítás, nem minden futott le';
C_MSG_ALLDONE = 'minden lefutott (%04u/%02u/%02u-%02u:%02u:%02u)';
C_MSG_OPTABLES_LOADED = '(beolvasva %u op.tábla)';
C_MSG_TIMER_HLT = 'Feldolgozás megállítva %u:%u:%u-ig';
C_MSG_TIMER_REST = '%u:%u:%u-et ütött már az óra, feldolgozás folytatása';
C_MSG_COOLDOWN_HLT = 'Feldolgozás felfüggesztve %u:%u:%u idõre';
C_MSG_COOLDOWN_REST = '%u:%u:%u -- feldolgozás folytatása';
C_MSG_SEARCH_HLT = 'Várakozás újabb feladatokra %u:%u:%u ideig';

C_MSG_INCREASINGDITABLE = 'DITable mérete megnövelve: %u -> %u';
C_MSG_SEARCHDATSETSMULTIDIR = 'Több különbözõ könyvtárból nem tudok dolgozni (%s,%s)!';
C_MSG_INVALIDFILENAME1 = 'Páratlan ''['' vagy '']'' a fájlnévben: %s. Nem értem.';
C_MSG_INVALIDFILENAME2 = 'Túl sok (több, mint kettõ) ''[...]'' szekció a fájlnévben: %s. Nem értem.';
C_MSG_INTERNAL_POSTFIX = ' --> Furcsa hiba.';
C_MSG_CANNOT_PACK_FN_NO_SUBJECT = ['A PackFilename() nem kapott subjectet. (%s;%s;%s;%s;%s;%s;%s)' C_MSG_INTERNAL_POSTFIX];
C_MSG_CANNOT_PACK_SN_NO_SUBJECT = ['A PackSetname() nem kapott subjectet. (%s;%s;%s;%s;%s;%s;%s)' C_MSG_INTERNAL_POSTFIX];
C_MSG_ERRORCHK = 'Hiba a %s plugin ellenõrzõ végrehajtásakor: %s';
C_MSG_EXCEPTION_ONLY_CODE = '(hibakód: %u)';
C_MSG_NOPLUGIN_WARNING = 'Vigyázat! Bizonyos pluginek hiányoznak, ezeket kihagyjuk.';
C_MSG_MULTI_WARNING = 'Vigyázat! Egyszerre akar kezelni dataseteket olyan pluginekkel, amelyek erre nem alkalmasak! Ez nem fog futni.';
C_MSG_NOPLUGIN_ERROR = 'HIBA! A következõ plugint nem találom: %s';
C_MSG_MULTI_ERROR = 'HIBA! Egyszerre akar kezelni több datasetet, ez a plugin nem alkalmas rá: %s';
C_MSG_THIS_USERMODE_SKIPPED = '--kézi módú--';
C_MSG_THIS_AUTOMODE_SKIPPED = '--auto módú--';
C_MSG_THIS_DONE = '(korábban már elkészült)';
C_MSG_THIS_NOPLUGIN = '(ERR: nem találom a plugint)';
C_MSG_THIS_ERRORCHK = '(ERR: hiba ellenõrzés közben)';
C_MSG_THIS_ERRORRUN = '(ERR: hiba (korábban) futás közben)';
C_MSG_THIS_MULTIERROR = '(ERR: ez a plugin nem tud több datasettel dolgozni)';
C_MSG_THIS_MUTEXERROR = '(mutex: más csinálja éppen)';
C_MSG_THIS_EXOTIC = 'EXOTIKUS hibakód: %u';
C_MSG_THIS_OPTMANAGEMENT = 'KÉSÕBBre halasztva';

C_MSG_PLUGIN_CANNOT_SELFCHECK = 'Ez a plugin nem képes önellenõzésre! (Valószínûleg az OP-táblában nincs kitöltve a megfelelõ sor kimeneti mezõje vagy máshogy szabálytalan.)'; % v0.1.022 (átfogalmazás)
C_MSG_NOPATHBUTFILES = 'Nem tudjuk meghatározni a kiválasztott fájlok útvonalát. Próbálja nem fájlonként!'; % v0.2.003 - C_MSG_INTERNAL_POSTFIX removed from the following lines
C_MSG_FSMUTEX_NOCREATE = 'Mutex (%s) nem jött létre!'; % v0.1.016
C_MSG_FSMUTEX_NOTEXIST = 'Mutex (%s) nem létezett!';
C_MSG_FSMUTEX_NODELETE = 'A mutexet (%s) nem sikerült törölni!';
C_MSG_FSMUTEX_NOCREATE2 = 'A mutexet (%s) nem lehetett megnyitni/létrehozni!';
C_MSG_FSMUTEX_NOOWNER = 'A mutexnek (%s) úgy tûnik, nincs gazdája!';
C_MSG_FSMUTEX_DIFFOWNER = 'A mutexet (%s) épp felszabadítjuk, de kiderült, hogy más hozta létre: %s';

C_MSG_MTXCLEARED = '%u korábbi árván maradt mutexet töröltem';
C_MSG_MTXCLEARED2 = 'Figyelem! Eltávolítva összesen %u árva mutex. A következõ gépeken összeomlás történhetett: %s';

C_MSG_FLOGREINIT = 'Hiba történt korábban a fájlnaplózás során. Megpróbáljuk újra.';
C_MSG_ELOGREINIT = 'Hiba történt korábban a hibanapló kezelése során. Megpróbáljuk újra.';
C_MSG_XLOGREINIT = 'Hiba történt korábban a debugnapló kezelése során. Megpróbáljuk újra.';
C_MSG_NEWLOGFILE = 'Naplófájl: %s';
C_MSG_CANNOTCONDENSE = 'Hiba a korábbi logfájlok tömörítése közben: %s (fájl: %s)';

C_MSG_FILELOGERROR = 'Naplófájl (%s) megnyitási/írási hiba: %s. Fájlba napolózás ideiglenesen kikapcsolva.';
C_MSG_ERRORLOGERROR = 'Hibanapló (%s) megnyitási/írási hiba: %s. Külön hibanaplózás ideiglenesen kikapcsolva.';
C_MSG_XLOGERROR = 'Debuglog (%s) megnyitási/írási hiba: %s. Debugnapló egy idõre kikapcsolva.';
C_MSG_XLOGEXCEPTION = 'Debuglog hiba: %s. Debugnapló egy idõre kikapcsolva.\n';
C_MSG_OPTABLEIOERR = 'OPtábla (%s) megnyitási/olvasási hiba: %s. OPtábla kihagyva.';
C_MSG_OPTABLEERR = 'Strukturális hiba: nincs meg legalább 5 oszlop';

C_MSG_DSETLOGLINE1MEM = 'MATLAB uses %u MiB\t\tMax array %u MiB\t\tPhys avail %u MiB\t\t%u files opened';
C_MSG_DSETLOGLINE1NOMEM = '';	% fix(clock) % v0.1.019 - felesleges idõpecsét eltûntetve
C_MSG_DSETLOGLINE1B_UNMEASURABLE = 'Plugin time unmeasurable';
C_MSG_DSETLOGLINE1B = 'Plugin time %u:%.2f\t\t%.2f epochs/sec\t\t%.2f samples/sec';
C_MSG_DSETLOGLINE2 = '%s ----> %s ----> %s';	% infile,Func,outfile
C_MSG_DSETLOGLINE3S = 'paraméterek: %s';	% params
C_MSG_DSETLOGLINE3M = 'paraméterek: %s, együtt: %s';	% params,condslist
C_MSG_DSETLOGLINE3E = 'paraméterek: %s, HIBA: %s';	% params,error
C_MSG_DSETLOGLINE4 = '-----------------';

C_MSG_VLOGADD = 'KÉSZ (kód:%u) (%04u/%02u/%02u-%02u:%02u:%02u)';	% error, fix(clock)
C_MSG_LISTDITABLE_NOINFILE = ['Üres ''infile'' mezõ az OPtáblában!' C_MSG_INTERNAL_POSTFIX];
C_MSG_LISTDITABLE_INTERNAL_OUTPHASE = '<INTERNAL>';
C_MSG_PATHADDED = 'added to path: %s';

C_DISP_MAINWNDCLOSING = 'EEGbatch: fõablak lezárása';
C_DISP_EEGBATCHRESTART = 'EEGbatch: restart';

C_DISP_SETTINGSLOADED = 'Beállítások betöltve %s fájlból\n';
C_DISP_SETTINGSSAVED = 'Beállítások mentve (%s)\n';
C_MSG_LOADSETERR = 'Hiba a beállítások betöltése közben (fájl: %s, hiba: %s)';
C_MSG_LOADSETERR2 = 'Hiba a beállítások betöltése közben: %s';
C_MSG_SAVESETERR = 'Hiba a beállítások mentése közben (fájl: %s, hiba: %s)';
C_MSG_SAVESETERR2 = 'Hiba a beállítások betöltése közben: %s'; 

C_MSG_FREQINROW_NOBANDFILE = 'DO_freqinrow: A bandsetupfile (%s) nem létezik? (hibaüzenet: %s)';
C_MSG_FREQINROW_NOCHANLOCS = 'Nem tudok anterior-posterior/bal-jobb elemzést csinálni, nincs channel locations megadva! ';
C_MSG_FREQINROW_FILEERR1 = 'DO_freqinrow: Az spss header/output fájl (%s) megnyitása közben a következõ hibát jelezte a rendszer: %s';
C_MSG_FREQINROW_FILEERR2 = 'DO_freqinrow: Az spss output fájl (%s) megnyitása közben a következõ hibát jelezte a rendszer: %s';
C_MSG_FREQINROW_CHANNELERR = 'DO_freqinrow: a spectopo() nem szabályos csatornát talált. Talán bennmaradt egy signalcsatorna?';
C_MSG_FREQINROW_EMPTYBAND = 'DO_freqinrow: a spectopo() nem talált %s tartományba (%.1f-%.1f) esõ hullámot!';
C_MSG_FREQINROW = '%ux%u CSV-tábla kiírva %s fájlba';
C_DISP_FREQINROW_ANTEPOSTE = 'Ante/poste/left/right: %u/%u/%u/%u, pontosabban: ante: %s, poste: %s, left: %s, right: %s\n';
C_DISP_FREQINROW_PROCESSING = '%u/%u epoch feldolgozása (fájl ETA: %02u:%02u:%02u)...\n';
C_DISP_FREQINROW_DONE = '%ux%u CSV-tábla kiírva %s fájlba\n';

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

C_MSG_SELECT = 'pop_select() lefutott, EEGdata mérete: ';


C_MSG_PERFINDEXMUTEXERROR = 'Nem tudom elérni a %s fájlt, más folyamat használja éppen (hosszú idõn keresztül tartó mutex error). Árva mutex lehet? Esetleg egy cleanup segítene?'; 
C_MSG_ERRORLOGMUTEXERROR = 'Nem tudom elérni a %s fájlt, más folyamat használja éppen (hosszú idõn keresztül tartó mutex error). Árva mutex lehet? Esetleg egy cleanup segítene?'; 
C_MSG_XLOGMUTEXERROR = 'Nem tudom elérni a %s fájlt, más folyamat használja éppen (hosszú idõn keresztül tartó mutex error). Árva mutex lehet? Esetleg egy cleanup segítene?'; 
C_MSG_CALCULATING_PI = 'PIndex kiszámítása...';
C_MSG_GOT_PI = 'Optimalizált százalék: %u, PIndex: %u (MF:%u), %u elem a PIndex-táblában';
C_MSG_PI_OVR = 'Optimalizált százalék: %u (kézi beállítás)';

C_MSG_INTERRORSD = ['LEÁLLT: váratlan hiba történt a feladatok felkutatása közben: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_INTERRORPR = ['LEÁLLT: váratlan hiba történt a feladatok végrehajtása közben: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_INTERRORLDI = ['LEÁLLT: váratlan hiba történt a feladatok listázása közben: %s' C_MSG_INTERNAL_POSTFIX];
C_MSG_ERRORSD = 'LEÁLLT: hiba a feladatok felkutatásakor: %s';
C_MSG_ERRORPR = 'LEÁLLT: hiba a feladatok végrehajtásakor: %s';

C_DI_PLUGINEDITOR_CAPTION = 'EEGbatch Plugin-szerkesztõ';
C_DI_PLUGINEDITOR_PLUGINNAME = 'plugin neve:';
C_DI_PLUGINEDITOR_PLUGINPARAMS = 'paraméterek:';
C_DI_PLUGINEDITOR_SAVE = 'MENTÉS';
C_DI_PLUGINEDITOR_FUNCTIONFORMAT = 'function [funcres, EEG, logstr] = %s(dataset,EEG,wtd%s)';
C_DI_HELP1 = { ...
    'Némi segítség:', ...
    '', ...
    'dataset.FN........fájlnév', ...
    'dataset.Prj.......projektnév', ...
    'dataset.SubjGr....alanycsoport', ...
    'dataset.Subj......alany', ...
    'dataset.Cond......kondíció', ...
    '(ha több datasetet is kaphat,', ...
    'akkor dataset(i).FN stb.)'};

C_DI_HELP2 = { ...
    'EEG..........nyilván', ...
    'wtd..........''run'' vagy ''check'' (utóbbit csak akkor kell implementálni, ha a plugin maga ellenõrzi, hogy lefutott-e már)', ...
    'funcres.......ebben adjuk vissza a státuszt, <0: hiba történt, >0: tájékoztató'};

C_DI_PE_BODY = {'% innentõl kezdõdik a plugin kódja', ...
		'if strcmpi(wtd,''run'')', ...
		'% csak, ha wtd == ''run''', ...
		 '', ...
		'    % a tényleges kód', ...
		'', ...
		'end;'};

C_DI_PE_POSTFIX = 'end';
