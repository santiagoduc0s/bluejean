import 'package:flutter/widgets.dart';
import 'package:lune/core/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

Map<String, String Function(Object)> validationMessages(BuildContext context) =>
    {
      ValidationMessage.any: (error) =>
          context.read<Localization>().tr.validation_any,
      ValidationMessage.compare: (error) =>
          context.read<Localization>().tr.validation_compare,
      ValidationMessage.contains: (error) =>
          context.read<Localization>().tr.validation_contains,
      ValidationMessage.creditCard: (error) =>
          context.read<Localization>().tr.validation_creditCard,
      ValidationMessage.email: (error) =>
          context.read<Localization>().tr.validation_email,
      ValidationMessage.equals: (error) =>
          context.read<Localization>().tr.validation_equals,
      ValidationMessage.max: (error) {
        final max = (error as Map<String, dynamic>)['max'] as int;
        return context.read<Localization>().tr.validation_max(max);
      },
      ValidationMessage.maxLength: (error) {
        final requiredLength =
            (error as Map<String, dynamic>)['requiredLength'] as int;
        return context
            .read<Localization>()
            .tr
            .validation_maxLength(requiredLength);
      },
      ValidationMessage.min: (error) {
        final min = (error as Map<String, dynamic>)['min'] as int;
        return context.read<Localization>().tr.validation_min(min);
      },
      ValidationMessage.minLength: (error) {
        final requiredLength =
            (error as Map<String, dynamic>)['requiredLength'] as int;
        return context
            .read<Localization>()
            .tr
            .validation_minLength(requiredLength);
      },
      ValidationMessage.mustMatch: (error) =>
          context.read<Localization>().tr.validation_mustMatch,
      ValidationMessage.number: (error) =>
          context.read<Localization>().tr.validation_number,
      ValidationMessage.pattern: (error) =>
          context.read<Localization>().tr.validation_pattern,
      ValidationMessage.required: (error) =>
          context.read<Localization>().tr.validation_required,
      ValidationMessage.requiredTrue: (error) =>
          context.read<Localization>().tr.validation_requiredTrue,
    };
