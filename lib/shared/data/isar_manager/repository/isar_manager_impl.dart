import 'package:aurora/shared/data/isar_manager/models/ar_profile_model.dart';
import 'package:aurora/shared/data/isar_manager/models/ar_settings_model.dart';
import 'package:aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:aurora/shared/data/model/ar_mode_model.dart';
import 'package:aurora/shared/data/model/ar_state_model.dart';
import 'package:aurora/utility/ar_widgets/ar_colors.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


class IsarManagerImpl implements IsarManager {

  late Isar isar;

  ArSettingsModel _arSettingsModel=ArSettingsModel();
  late ArProfileModel _arProfileModel;

  @override
  Future initIsar() async{

    isar = await Isar.open(
      name: 'arDB',
      [ArSettingsModelSchema,ArProfileModelSchema],
      directory: (await getApplicationSupportDirectory()).path
    );

   if((await isar.arSettingsModels.where().findAll()).isEmpty){
     await _initArSettings();
   }

   await readArSettingsIsar();
   await readArProfileIsar();

   print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
   print("Profile ID - ${_arSettingsModel.profileId}");
   print("Profile Name - ${_arProfileModel.profileName}");
   print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");


  }

  Future _initArSettings() async{
    _arSettingsModel=ArSettingsModel(
        arTheme: 'system',
        arVersion: '0',
        profileId: await _initArProfiles());

    await writeArSettingsIsar();
  }

  Future<int> _initArProfiles() async{
    print("initing isar profile");
    _arProfileModel=ArProfileModel(
        profileName: 'Default Profile',
        threshold: 55,
        brightness: 1,
        arState: const ArState(),
        arMode: ArMode(colorRad: ArColors.accentColor.value,mode: 1,speed: 0 ));
    await writeArProfileIsar();
    return (await isar.arProfileModels.where().findFirst())!.id!;
  }
  
  /// Ar Settings Isar

  @override
  Future writeArSettingsIsar() async{
    if(_arSettingsModel.profileId!=null) {
      await isar.writeTxn(() => isar.arSettingsModels.put(_arSettingsModel));
      await readArSettingsIsar();
    }
  }

  @override
  Future<ArSettingsModel?> readArSettingsIsar() async{
    var tempModel= await isar.arSettingsModels.where().findFirst();
    if(tempModel!=null) {
      _arSettingsModel=tempModel;
    }
    return tempModel;
  }  

  @override
  Future deleteArSettingsIsar(int id) async{
    _arSettingsModel=ArSettingsModel();
    return await isar.arSettingsModels.delete(id);
  }

  /// AR Profile ISAR
  @override
  Future writeArProfileIsar({ArProfileModel? arProfileModel}) async{
    arProfileModel??=_arProfileModel;
    await isar.writeTxn(() => isar.arProfileModels.put(arProfileModel!));
    _arSettingsModel.profileId=_arProfileModel.id;
    await writeArSettingsIsar();
    await readArProfileIsar();
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    print("Profile ID - ${_arSettingsModel.profileId}");
    print("Profile Name - ${_arProfileModel.profileName}");
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
  }

  @override
  Future<ArProfileModel?> readArProfileIsar({int? id}) async{
    id??=_arSettingsModel.profileId;
    ArProfileModel? tempModel= await isar.arProfileModels.get(id!);
    if(tempModel!=null){
      _arProfileModel=tempModel;
    }
    return tempModel;
  }

  @override
  Future<List<ArProfileModel>> readAllArProfileIsar() async{
    return isar.arProfileModels.where().findAll();
  }

  @override
  Future deleteArProfileIsar({int? id}) async{
    id??=_arSettingsModel.profileId;
    await isar.arProfileModels.delete(id!);
  }

  @override
  Future deleteDatabase() async{
    isar.close(deleteFromDisk: true);
  }


  @override
  set arProfileModel(ArProfileModel value) {
    _arProfileModel = value;
  }

  @override
  ArSettingsModel get arSettingsModel=> _arSettingsModel;

  @override
  ArProfileModel get arProfileModel=> _arProfileModel;

}