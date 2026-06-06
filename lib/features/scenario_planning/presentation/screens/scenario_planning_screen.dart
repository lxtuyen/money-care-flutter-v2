import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/app/widgets/layout/app_header.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';
import 'package:money_care/features/scenario_planning/presentation/controllers/scenario_planning_controller.dart';
import 'package:money_care/features/scenario_planning/presentation/widgets/scenario_result_card.dart';
import 'package:money_care/features/scenario_planning/presentation/widgets/scenario_template_card.dart';

class ScenarioPlanningScreen extends StatefulWidget {
  const ScenarioPlanningScreen({super.key});

  @override
  State<ScenarioPlanningScreen> createState() => _ScenarioPlanningScreenState();
}

class _ScenarioPlanningScreenState extends State<ScenarioPlanningScreen> {
  final controller = Get.find<ScenarioPlanningController>();
  final _formKey = GlobalKey<FormState>();
  final _fieldControllers = <String, TextEditingController>{};
  int? _initialGoalId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['goalId'] is int) {
      _initialGoalId = args['goalId'] as int;
    }
  }

  @override
  void dispose() {
    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Mô phỏng tài chính',
              showBackButton: true,
              height: 120,
              child: SizedBox.shrink(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTemplates.value &&
                    controller.templates.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final template = controller.selectedTemplate.value;
                if (template == null) {
                  return const Center(
                    child: Text('Chưa có kịch bản mô phỏng khả dụng'),
                  );
                }

                _syncControllers(template);

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 146,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final item = controller.templates[index];
                            return ScenarioTemplateCard(
                              template: item,
                              selected:
                                  item.scenarioType == template.scenarioType,
                              onTap: () => controller.selectTemplate(item),
                            );
                          },
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemCount: controller.templates.length,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _ScenarioInputPanel(
                        template: template,
                        formKey: _formKey,
                        fieldControllers: _fieldControllers,
                        onDateTap: _pickDate,
                        onSubmit: _submit,
                        isSubmitting: controller.isSimulating.value,
                      ),
                      if (controller.errorMessage.value.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (controller.simulationResult.value != null) ...[
                        const SizedBox(height: 18),
                        ScenarioResultCard(
                          result: controller.simulationResult.value!,
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _syncControllers(ScenarioTemplateModel template) {
    for (final field in template.fields) {
      final fieldController = _fieldControllers.putIfAbsent(
        field.name,
        () => TextEditingController(),
      );
      if (field.name == 'goalId' &&
          _initialGoalId != null &&
          fieldController.text.isEmpty) {
        fieldController.text = _initialGoalId.toString();
      }
    }
  }

  Future<void> _pickDate(ScenarioTemplateFieldModel field) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (selected == null) return;
    _fieldControllers[field.name]?.text = DateFormat(
      'yyyy-MM-dd',
    ).format(selected);
  }

  Future<void> _submit(ScenarioTemplateModel template) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = <String, dynamic>{};
    int? goalId;

    for (final field in template.fields) {
      final raw = _fieldControllers[field.name]?.text.trim() ?? '';
      if (raw.isEmpty && !field.required) continue;
      if (field.type == 'money' ||
          field.type == 'number' ||
          field.type == 'percent') {
        final value = _parseNumber(raw);
        params[field.name] = field.name == 'goalId' ? value.toInt() : value;
        if (field.name == 'goalId') goalId = value.toInt();
      } else {
        params[field.name] = raw;
      }
    }

    await controller.simulate(
      scenarioType: template.scenarioType,
      params: params,
      goalIds: goalId != null ? [goalId] : null,
    );
  }

  double _parseNumber(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}

class _ScenarioInputPanel extends StatelessWidget {
  final ScenarioTemplateModel template;
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> fieldControllers;
  final Future<void> Function(ScenarioTemplateFieldModel field) onDateTap;
  final Future<void> Function(ScenarioTemplateModel template) onSubmit;
  final bool isSubmitting;

  const _ScenarioInputPanel({
    required this.template,
    required this.formKey,
    required this.fieldControllers,
    required this.onDateTap,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    template.title,
                    style: const TextStyle(
                      color: AppColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...template.fields.map(
              (field) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ScenarioInputField(
                  field: field,
                  controller: fieldControllers[field.name]!,
                  onDateTap: () => onDateTap(field),
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : () => onSubmit(template),
                icon: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: const Text('Mô phỏng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenarioInputField extends StatelessWidget {
  final ScenarioTemplateFieldModel field;
  final TextEditingController controller;
  final VoidCallback onDateTap;

  const _ScenarioInputField({
    required this.field,
    required this.controller,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNumber =
        field.type == 'money' ||
        field.type == 'number' ||
        field.type == 'percent';
    final isDate = field.type == 'date';

    return TextFormField(
      controller: controller,
      readOnly: isDate,
      onTap: isDate ? onDateTap : null,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]
          : [],
      decoration: InputDecoration(
        labelText: field.label,
        suffixText: field.type == 'money'
            ? 'VND'
            : field.type == 'percent'
            ? '%'
            : null,
        prefixIcon: Icon(_fieldIcon(field)),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (field.required && text.isEmpty) {
          return 'Vui lòng nhập ${field.label.toLowerCase()}';
        }
        if (isNumber && text.isNotEmpty) {
          final parsed = double.tryParse(text);
          if (parsed == null || parsed <= 0) {
            return 'Giá trị phải lớn hơn 0';
          }
        }
        return null;
      },
    );
  }
}

IconData _fieldIcon(ScenarioTemplateFieldModel field) {
  if (field.type == 'money') return Icons.payments_outlined;
  if (field.type == 'percent') return Icons.percent_rounded;
  if (field.type == 'date') return Icons.event_rounded;
  if (field.name == 'goalId') return Icons.flag_circle_outlined;
  return Icons.short_text_rounded;
}
