import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_widgets/ubuntu_widgets.dart';
import 'package:ubuntu_wizard/constants.dart';
import 'package:ubuntu_wizard/utils.dart';
import 'package:ubuntu_wizard/widgets.dart';

import '../../l10n.dart';
import '../../services.dart';
import 'choose_security_key_model.dart';

part 'choose_security_key_widgets.dart';

/// Choose security key page.
///
/// See also:
/// * [ChooseSecurityKeyModel]
class ChooseSecurityKeyPage extends StatefulWidget {
  /// Use [create] instead.
  @visibleForTesting
  const ChooseSecurityKeyPage({
    super.key,
  });

  /// Creates an instance with [ChooseSecurityKeyModel].
  static Widget create(BuildContext context) {
    final service = getService<DiskStorageService>();
    return ChangeNotifierProvider(
      create: (_) => ChooseSecurityKeyModel(service),
      child: const ChooseSecurityKeyPage(),
    );
  }

  @override
  State<ChooseSecurityKeyPage> createState() => _ChooseSecurityKeyPageState();
}

class _ChooseSecurityKeyPageState extends State<ChooseSecurityKeyPage> {
  @override
  void initState() {
    super.initState();
    final model = Provider.of<ChooseSecurityKeyModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadSecurityKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final flavor = Flavor.of(context);
    return WizardPage(
      title: Text(lang.chooseSecurityKeyTitle),
      header: FractionallySizedBox(
        widthFactor: kContentWidthFraction,
        child: Text(lang.chooseSecurityKeyHeader(flavor.name)),
      ),
      content: LayoutBuilder(builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth * kContentWidthFraction;
        return ListView(
          children: <Widget>[
            _SecurityKeyFormField(fieldWidth: fieldWidth),
            const SizedBox(height: kContentSpacing),
            _ConfirmSecurityKeyFormField(fieldWidth: fieldWidth),
            const SizedBox(height: kContentSpacing / 2),
            const _SecurityKeyShowButton(),
            const SizedBox(height: kContentSpacing),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: kContentWidthFraction,
                child: Html(
                  data: lang.chooseSecurityKeyWarning(
                      Theme.of(context).errorColor.toHex()),
                  style: {'body': Style(margin: EdgeInsets.zero)},
                ),
              ),
            ),
          ],
        );
      }),
      actions: <WizardAction>[
        WizardAction.back(context),
        WizardAction.next(
          context,
          enabled: context
              .select<ChooseSecurityKeyModel, bool>((model) => model.isValid),
          onNext: context.read<ChooseSecurityKeyModel>().saveSecurityKey,
          onBack: context.read<ChooseSecurityKeyModel>().loadSecurityKey,
        ),
      ],
    );
  }
}
