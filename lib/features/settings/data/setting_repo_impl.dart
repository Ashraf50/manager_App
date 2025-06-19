import 'package:manager_app/core/constant/app_strings.dart';
import 'package:manager_app/core/constant/func/get_token.dart';
import 'package:manager_app/core/helper/api_helper.dart';
import 'package:manager_app/features/settings/data/setting_repo.dart';

class SettingRepoImpl implements SettingRepo {
  final ApiHelper apiHelper;
  SettingRepoImpl(this.apiHelper);
  @override
  Future<bool> fetchAutomaticAssignment() async {
    try {
      final token = await getToken();
      final response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/managers/me/settings',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.data['data']['automatic_assignment'] as bool;
      }
    } catch (e) {
      print("Fetch Error: $e");
    }
    return false;
  }

  @override
  Future<void> updateAutomaticAssignment(bool value) async {
    try {
      final token = await getToken();
      await apiHelper.patch(
        '${AppStrings.baseUrl}/api/managers/me/settings',
        data: {
          "automatic_assignment": value,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print("Update Error: $e");
    }
  }
}
