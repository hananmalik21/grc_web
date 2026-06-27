import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/hiring/presentation/models/candidate_stat_data.dart';
import 'package:grc/gen/assets.gen.dart';

class ApplicationsTabConfig {
  const ApplicationsTabConfig._();

  static const int pageSize = 10;

  static List<CandidateStatData> buildStatCards(AppLocalizations loc) {
    return [
      CandidateStatData(
        title: loc.hiringApplicationsStatTotal,
        value: '5',
        subtext: loc.hiringApplicationsStatTotalSubtext,
        iconPath: Assets.icons.usersIcon.path,
        showTrendIcon: true,
      ),
      CandidateStatData(
        title: loc.hiringApplicationsStatNew,
        value: '0',
        subtext: loc.hiringApplicationsStatNewSubtext,
        iconPath: Assets.icons.clockIcon.path,
      ),
      CandidateStatData(
        title: loc.hiringApplicationsStatInterview,
        value: '1',
        subtext: loc.hiringApplicationsStatInterviewSubtext,
        iconPath: Assets.icons.usersIcon.path,
      ),
      CandidateStatData(
        title: loc.hiringApplicationsStatCareerSite,
        value: '0',
        subtext: loc.hiringApplicationsStatCareerSiteSubtext,
        iconPath: Assets.icons.hiring.careerSite.path,
      ),
    ];
  }
}
