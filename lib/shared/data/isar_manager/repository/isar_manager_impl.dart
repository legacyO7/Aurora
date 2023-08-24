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

  }

  Future _initArSettings() async{
    _arSettingsModel=ArSettingsModel(
        arTheme: 'system',
        arVersion: '0',
        profileId: await _initArProfiles());

    await writeArSettingsIsar();
  }

  Future<int> _initArProfiles() async{
    _arProfileModel=ArProfileModel(
        profileName: 'Default Profile',
        threshold: 55,
        brightness: 1,
        arState: ArState(),
        arMode: ArMode(colorRad: ArColors.accentColor.value,mode: 1,speed: 0 ));
    await writeArProfileIsar();
    return (await isar.arProfileModels.where().findFirst())!.id!;
  }
  
  /// Ar Settings Isar

  @override
  Future writeArSettingsIsar() async{
    await isar.writeTxn(() => isar.arSettingsModels.put(arSettingsModel));
    await readArSettingsIsar();
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
  Future writeArProfileIsar() async{
    await isar.writeTxn(() => isar.arProfileModels.put(arProfileModel));
    await readArProfileIsar();
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
  Future deleteArProfileIsar({int? id}) async{
    id??=_arSettingsModel.profileId;
    await isar.arProfileModels.delete(id!);
  }

  @override
  Future deleteDatabase() async{
    isar.close(deleteFromDisk: true);
  }

  @override
  ArSettingsModel get arSettingsModel=> _arSettingsModel;
  ArProfileModel get arProfileModel=> _arProfileModel;

}