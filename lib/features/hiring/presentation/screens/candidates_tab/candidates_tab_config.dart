import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/hiring/presentation/models/candidate_stat_data.dart';
import 'package:grc/gen/assets.gen.dart';

class CandidatesTabConfig {
  const CandidatesTabConfig._();

  static const int pageSize = 10;

  static List<CandidateStatData> buildStatCards(AppLocalizations loc) {
    return [
      CandidateStatData(
        title: loc.hiringCandidatesStatTotal,
        value: '124',
        subtext: loc.hiringCandidatesStatTotalSubtext,
        iconPath: Assets.icons.employeeListIcon.path,
        showTrendIcon: true,
      ),
      CandidateStatData(
        title: loc.hiringCandidatesStatShortlisted,
        value: '42',
        subtext: loc.hiringCandidatesStatShortlistedSubtext,
        iconPath: Assets.icons.sectionIconSmall.path,
      ),
      CandidateStatData(
        title: loc.hiringCandidatesStatInterviewed,
        value: '18',
        subtext: loc.hiringCandidatesStatInterviewedSubtext,
        iconPath: Assets.icons.clockIcon.path,
      ),
      CandidateStatData(
        title: loc.hiringCandidatesStatHired,
        value: '12',
        subtext: loc.hiringCandidatesStatHiredSubtext,
        iconPath: Assets.icons.priceUpItem.path,
      ),
    ];
  }
}
