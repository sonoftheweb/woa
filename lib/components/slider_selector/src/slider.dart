import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';

import 'common.dart';
import 'constants.dart';
import 'slider_base.dart';
import 'slider_shapes.dart';

class SfSlider extends StatefulWidget {
  /// Creates a horizontal [SfSlider].
  const SfSlider(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      required this.value,
      required this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDividers = false,
      this.enableTooltip = false,
      this.shouldAlwaysShowTooltip = false,
      this.activeColor,
      this.inactiveColor,
      this.labelPlacement = LabelPlacement.onTicks,
      this.edgeLabelPlacement = EdgeLabelPlacement.auto,
      this.numberFormat,
      this.dateFormat,
      this.dateIntervalType,
      this.labelFormatterCallback,
      this.tooltipTextFormatterCallback,
      this.semanticFormatterCallback,
      this.trackShape = const SfTrackShape(),
      this.dividerShape = const SfDividerShape(),
      this.overlayShape = const SfOverlayShape(),
      this.thumbShape = const SfThumbShape(),
      this.tickShape = const SfTickShape(),
      this.minorTickShape = const SfMinorTickShape(),
      this.tooltipShape = const SfRectangularTooltipShape(),
      this.thumbIcon})
      : isInversed = false,
        _sliderType = SliderType.horizontal,
        _tooltipPosition = null,
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  /// Creates a vertical [SfSlider].
  const SfSlider.vertical(
      {Key? key,
      this.min = 0.0,
      this.max = 1.0,
      required this.value,
      required this.onChanged,
      this.onChangeStart,
      this.onChangeEnd,
      this.interval,
      this.stepSize,
      this.stepDuration,
      this.minorTicksPerInterval = 0,
      this.showTicks = false,
      this.showLabels = false,
      this.showDividers = false,
      this.enableTooltip = false,
      this.shouldAlwaysShowTooltip = false,
      this.isInversed = false,
      this.activeColor,
      this.inactiveColor,
      this.labelPlacement = LabelPlacement.onTicks,
      this.edgeLabelPlacement = EdgeLabelPlacement.auto,
      this.numberFormat,
      this.dateFormat,
      this.dateIntervalType,
      this.labelFormatterCallback,
      this.tooltipTextFormatterCallback,
      this.semanticFormatterCallback,
      this.trackShape = const SfTrackShape(),
      this.dividerShape = const SfDividerShape(),
      this.overlayShape = const SfOverlayShape(),
      this.thumbShape = const SfThumbShape(),
      this.tickShape = const SfTickShape(),
      this.minorTickShape = const SfMinorTickShape(),
      this.tooltipShape = const SfRectangularTooltipShape(),
      this.thumbIcon,
      SliderTooltipPosition tooltipPosition = SliderTooltipPosition.left})
      : _sliderType = SliderType.vertical,
        _tooltipPosition = tooltipPosition,
        assert(tooltipShape is! SfPaddleTooltipShape),
        assert(min != max),
        assert(interval == null || interval > 0),
        super(key: key);

  final SliderType _sliderType;

  /// This is only applicable for vertical sliders.
  final SliderTooltipPosition? _tooltipPosition;

  final dynamic min;

  final dynamic max;

  final dynamic value;

  final ValueChanged<dynamic>? onChanged;

  final ValueChanged<dynamic>? onChangeStart;

  final ValueChanged<dynamic>? onChangeEnd;

  final double? interval;

  final double? stepSize;

  final SliderStepDuration? stepDuration;

  final int minorTicksPerInterval;

  final bool showTicks;

  final bool showLabels;

  final bool showDividers;

  final bool enableTooltip;

  final bool shouldAlwaysShowTooltip;

  final bool isInversed;

  final Color? inactiveColor;

  final Color? activeColor;

  final LabelPlacement labelPlacement;

  final EdgeLabelPlacement edgeLabelPlacement;

  final NumberFormat? numberFormat;

  final DateFormat? dateFormat;

  final DateIntervalType? dateIntervalType;

  final LabelFormatterCallback? labelFormatterCallback;

  final TooltipTextFormatterCallback? tooltipTextFormatterCallback;

  final SfSliderSemanticFormatterCallback? semanticFormatterCallback;

  /// Base class for [SfSlider] track shapes.
  final SfTrackShape trackShape;

  /// Base class for [SfSlider] dividers shapes.
  final SfDividerShape dividerShape;

  /// Base class for [SfSlider] overlay shapes.
  final SfOverlayShape overlayShape;

  ///  Base class for [SfSlider] thumb shapes.
  final SfThumbShape thumbShape;

  /// Base class for [SfSlider] major tick shapes.
  final SfTickShape tickShape;

  /// Base class for [SfSlider] minor tick shapes.
  final SfTickShape minorTickShape;

  final SfTooltipShape tooltipShape;

  final Widget? thumbIcon;

  @override
  State<SfSlider> createState() => _SfSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('value', value));
    properties.add(DiagnosticsProperty<dynamic>('min', min));
    properties.add(DiagnosticsProperty<dynamic>('max', max));
    properties.add(DiagnosticsProperty<bool>('isInversed', isInversed,
        defaultValue: false));
    properties.add(ObjectFlagProperty<ValueChanged<double>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'onChangeStart', onChangeStart));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'onChangeEnd', onChangeEnd));
    properties.add(DoubleProperty('interval', interval));
    properties.add(DoubleProperty('stepSize', stepSize));
    if (stepDuration != null) {
      properties.add(stepDuration!.toDiagnosticsNode(name: 'stepDuration'));
    }
    properties.add(IntProperty('minorTicksPerInterval', minorTicksPerInterval));
    properties.add(FlagProperty('showTicks',
        value: showTicks,
        ifTrue: 'Ticks are showing',
        ifFalse: 'Ticks are not showing'));
    properties.add(FlagProperty('showLabels',
        value: showLabels,
        ifTrue: 'Labels are showing',
        ifFalse: 'Labels are not showing'));
    properties.add(FlagProperty('showDividers',
        value: showDividers,
        ifTrue: 'Dividers are  showing',
        ifFalse: 'Dividers are not showing'));
    if (shouldAlwaysShowTooltip) {
      properties.add(FlagProperty('shouldAlwaysShowTooltip',
          value: shouldAlwaysShowTooltip, ifTrue: 'Tooltip is always visible'));
    } else {
      properties.add(FlagProperty('enableTooltip',
          value: enableTooltip,
          ifTrue: 'Tooltip is enabled',
          ifFalse: 'Tooltip is disabled'));
    }
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
    properties
        .add(EnumProperty<LabelPlacement>('labelPlacement', labelPlacement));
    properties.add(EnumProperty<EdgeLabelPlacement>(
        'edgeLabelPlacement', edgeLabelPlacement));
    properties
        .add(DiagnosticsProperty<NumberFormat>('numberFormat', numberFormat));
    if (value.runtimeType == DateTime && dateFormat != null) {
      properties.add(StringProperty(
          'dateFormat', 'Formatted value is ${dateFormat!.format(value)}'));
    }
    properties.add(
        EnumProperty<DateIntervalType>('dateIntervalType', dateIntervalType));
    properties.add(ObjectFlagProperty<TooltipTextFormatterCallback>.has(
        'tooltipTextFormatterCallback', tooltipTextFormatterCallback));
    properties.add(ObjectFlagProperty<LabelFormatterCallback>.has(
        'labelFormatterCallback', labelFormatterCallback));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'semanticFormatterCallback', semanticFormatterCallback));
  }
}

class _SfSliderState extends State<SfSlider> with TickerProviderStateMixin {
  late AnimationController overlayController;
  late AnimationController stateController;
  late AnimationController tooltipAnimationController;
  Timer? tooltipDelayTimer;
  final Duration duration = const Duration(milliseconds: 100);

  void _onChanged(dynamic value) {
    if (value != widget.value) {
      widget.onChanged!(value);
    }
  }

  void _onChangeStart(dynamic value) {
    if (widget.onChangeStart != null) {
      widget.onChangeStart!(value);
    }
  }

  void _onChangeEnd(dynamic value) {
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(value);
    }
  }

  String _getFormattedLabelText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  String _getFormattedTooltipText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  SfSliderThemeData _getSliderThemeData(ThemeData themeData, bool isActive) {
    SfSliderThemeData sliderThemeData = SfSliderTheme.of(context);
    final double minTrackHeight = math.min(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    final double maxTrackHeight = math.max(
        sliderThemeData.activeTrackHeight, sliderThemeData.inactiveTrackHeight);
    sliderThemeData = sliderThemeData.copyWith(
      activeTrackHeight: sliderThemeData.activeTrackHeight,
      inactiveTrackHeight: sliderThemeData.inactiveTrackHeight,
      tickOffset: sliderThemeData.tickOffset,
      inactiveLabelStyle: sliderThemeData.inactiveLabelStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1!.color!.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      activeLabelStyle: sliderThemeData.activeLabelStyle ??
          themeData.textTheme.bodyText1!.copyWith(
              color: isActive
                  ? themeData.textTheme.bodyText1!.color!.withOpacity(0.87)
                  : themeData.colorScheme.onSurface.withOpacity(0.32)),
      tooltipTextStyle: sliderThemeData.tooltipTextStyle ??
          themeData.textTheme.bodyText1!
              .copyWith(color: themeData.colorScheme.surface),
      inactiveTrackColor: widget.inactiveColor ??
          sliderThemeData.inactiveTrackColor ??
          themeData.colorScheme.primary.withOpacity(0.24),
      activeTrackColor: widget.activeColor ??
          sliderThemeData.activeTrackColor ??
          themeData.colorScheme.primary,
      thumbColor: widget.activeColor ??
          sliderThemeData.thumbColor ??
          themeData.colorScheme.primary,
      activeTickColor: sliderThemeData.activeTickColor ??
          themeData.colorScheme.onSurface.withOpacity(0.37),
      inactiveTickColor: sliderThemeData.inactiveTickColor ??
          themeData.colorScheme.onSurface.withOpacity(0.37),
      disabledActiveTickColor: sliderThemeData.disabledActiveTickColor ??
          themeData.colorScheme.onSurface.withOpacity(0.24),
      disabledInactiveTickColor: sliderThemeData.disabledInactiveTickColor ??
          themeData.colorScheme.onSurface.withOpacity(0.24),
      activeMinorTickColor: sliderThemeData.activeMinorTickColor ??
          themeData.colorScheme.onSurface.withOpacity(0.37),
      inactiveMinorTickColor: sliderThemeData.inactiveMinorTickColor ??
          themeData.colorScheme.onSurface.withOpacity(0.37),
      disabledActiveMinorTickColor:
          sliderThemeData.disabledActiveMinorTickColor ??
              themeData.colorScheme.onSurface.withOpacity(0.24),
      disabledInactiveMinorTickColor:
          sliderThemeData.disabledInactiveMinorTickColor ??
              themeData.colorScheme.onSurface.withOpacity(0.24),
      // ignore: lines_longer_than_80_chars
      overlayColor: widget.activeColor?.withOpacity(0.12) ??
          sliderThemeData.overlayColor ??
          themeData.colorScheme.primary.withOpacity(0.12),
      inactiveDividerColor: widget.activeColor ??
          sliderThemeData.inactiveDividerColor ??
          themeData.colorScheme.primary.withOpacity(0.54),
      activeDividerColor: widget.inactiveColor ??
          sliderThemeData.activeDividerColor ??
          themeData.colorScheme.onPrimary.withOpacity(0.54),
      disabledInactiveDividerColor:
          sliderThemeData.disabledInactiveDividerColor ??
              themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledActiveDividerColor: sliderThemeData.disabledActiveDividerColor ??
          themeData.colorScheme.onPrimary.withOpacity(0.12),
      disabledActiveTrackColor: sliderThemeData.disabledActiveTrackColor ??
          themeData.colorScheme.onSurface.withOpacity(0.32),
      disabledInactiveTrackColor: sliderThemeData.disabledInactiveTrackColor ??
          themeData.colorScheme.onSurface.withOpacity(0.12),
      disabledThumbColor: sliderThemeData.disabledThumbColor ??
          Color.alphaBlend(themeData.colorScheme.onSurface.withOpacity(0.38),
              themeData.colorScheme.surface),
      tooltipBackgroundColor: sliderThemeData.tooltipBackgroundColor ??
          (themeData.brightness == Brightness.light
              ? const Color.fromRGBO(97, 97, 97, 1)
              : const Color.fromRGBO(224, 224, 224, 1)),
      thumbStrokeColor: sliderThemeData.thumbStrokeColor,
      activeDividerStrokeColor: sliderThemeData.activeDividerStrokeColor,
      inactiveDividerStrokeColor: sliderThemeData.inactiveDividerStrokeColor,
      trackCornerRadius:
          sliderThemeData.trackCornerRadius ?? maxTrackHeight / 2,
      thumbRadius: sliderThemeData.thumbRadius,
      overlayRadius: sliderThemeData.overlayRadius,
      activeDividerRadius:
          sliderThemeData.activeDividerRadius ?? minTrackHeight / 4,
      inactiveDividerRadius:
          sliderThemeData.inactiveDividerRadius ?? minTrackHeight / 4,
      thumbStrokeWidth: sliderThemeData.thumbStrokeWidth,
      activeDividerStrokeWidth: sliderThemeData.activeDividerStrokeWidth,
      inactiveDividerStrokeWidth: sliderThemeData.inactiveDividerStrokeWidth,
    );
    if (widget._sliderType == SliderType.horizontal) {
      return sliderThemeData.copyWith(
          tickSize: sliderThemeData.tickSize ?? const Size(1.0, 8.0),
          minorTickSize: sliderThemeData.minorTickSize ?? const Size(1.0, 5.0),
          labelOffset: sliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(0.0, 5.0)
                  : const Offset(0.0, 13.0)));
    } else {
      return sliderThemeData.copyWith(
          tickSize: sliderThemeData.tickSize ?? const Size(8.0, 1.0),
          minorTickSize: sliderThemeData.minorTickSize ?? const Size(5.0, 1.0),
          labelOffset: sliderThemeData.labelOffset ??
              (widget.showTicks
                  ? const Offset(5.0, 0.0)
                  : const Offset(13.0, 0.0)));
    }
  }

  @override
  void didUpdateWidget(SfSlider oldWidget) {
    if (oldWidget.shouldAlwaysShowTooltip != widget.shouldAlwaysShowTooltip) {
      if (widget.shouldAlwaysShowTooltip) {
        tooltipAnimationController.value = 1;
      } else {
        tooltipAnimationController.value = 0;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    overlayController = AnimationController(vsync: this, duration: duration);
    stateController = AnimationController(vsync: this, duration: duration);
    tooltipAnimationController =
        AnimationController(vsync: this, duration: duration);
    stateController.value =
        widget.onChanged != null && (widget.min != widget.max) ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    overlayController.dispose();
    stateController.dispose();
    tooltipAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        widget.onChanged != null && (widget.min != widget.max);
    final ThemeData themeData = Theme.of(context);

    return _SliderRenderObjectWidget(
        key: widget.key,
        min: widget.min,
        max: widget.max,
        value: widget.value,
        onChanged: isActive ? _onChanged : null,
        onChangeStart: widget.onChangeStart != null ? _onChangeStart : null,
        onChangeEnd: widget.onChangeEnd != null ? _onChangeEnd : null,
        interval: widget.interval,
        stepSize: widget.stepSize,
        stepDuration: widget.stepDuration,
        minorTicksPerInterval: widget.minorTicksPerInterval,
        showTicks: widget.showTicks,
        showLabels: widget.showLabels,
        showDividers: widget.showDividers,
        enableTooltip: widget.enableTooltip,
        shouldAlwaysShowTooltip: widget.shouldAlwaysShowTooltip,
        isInversed: widget._sliderType == SliderType.horizontal &&
                Directionality.of(context) == TextDirection.rtl ||
            widget.isInversed,
        inactiveColor:
            widget.inactiveColor ?? themeData.primaryColor.withOpacity(0.24),
        activeColor: widget.activeColor ?? themeData.primaryColor,
        labelPlacement: widget.labelPlacement,
        edgeLabelPlacement: widget.edgeLabelPlacement,
        numberFormat: widget.numberFormat ?? NumberFormat('#.##'),
        dateIntervalType: widget.dateIntervalType,
        dateFormat: widget.dateFormat,
        labelFormatterCallback:
            widget.labelFormatterCallback ?? _getFormattedLabelText,
        tooltipTextFormatterCallback:
            widget.tooltipTextFormatterCallback ?? _getFormattedTooltipText,
        semanticFormatterCallback: widget.semanticFormatterCallback,
        trackShape: widget.trackShape,
        dividerShape: widget.dividerShape,
        overlayShape: widget.overlayShape,
        thumbShape: widget.thumbShape,
        tickShape: widget.tickShape,
        minorTickShape: widget.minorTickShape,
        tooltipShape: widget.tooltipShape,
        sliderThemeData: _getSliderThemeData(themeData, isActive),
        thumbIcon: widget.thumbIcon,
        tooltipPosition: widget._tooltipPosition,
        sliderType: widget._sliderType,
        state: this);
  }
}

class _SliderRenderObjectWidget extends RenderObjectWidget {
  const _SliderRenderObjectWidget(
      {Key? key,
      required this.min,
      required this.max,
      required this.value,
      required this.onChanged,
      required this.onChangeStart,
      required this.onChangeEnd,
      required this.interval,
      required this.stepSize,
      required this.stepDuration,
      required this.minorTicksPerInterval,
      required this.showTicks,
      required this.showLabels,
      required this.showDividers,
      required this.enableTooltip,
      required this.shouldAlwaysShowTooltip,
      required this.isInversed,
      required this.inactiveColor,
      required this.activeColor,
      required this.labelPlacement,
      required this.edgeLabelPlacement,
      required this.numberFormat,
      required this.dateFormat,
      required this.dateIntervalType,
      required this.labelFormatterCallback,
      required this.tooltipTextFormatterCallback,
      required this.semanticFormatterCallback,
      required this.trackShape,
      required this.dividerShape,
      required this.overlayShape,
      required this.thumbShape,
      required this.tickShape,
      required this.minorTickShape,
      required this.tooltipShape,
      required this.sliderThemeData,
      required this.thumbIcon,
      required this.state,
      required this.sliderType,
      required this.tooltipPosition})
      : super(key: key);

  final SliderType sliderType;
  final SliderTooltipPosition? tooltipPosition;
  final dynamic min;
  final dynamic max;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final ValueChanged<dynamic>? onChangeStart;
  final ValueChanged<dynamic>? onChangeEnd;
  final double? interval;
  final double? stepSize;
  final SliderStepDuration? stepDuration;
  final int minorTicksPerInterval;

  final bool showTicks;
  final bool showLabels;
  final bool showDividers;
  final bool enableTooltip;
  final bool isInversed;
  final bool shouldAlwaysShowTooltip;

  final Color inactiveColor;
  final Color activeColor;

  final LabelPlacement labelPlacement;
  final EdgeLabelPlacement edgeLabelPlacement;
  final NumberFormat numberFormat;
  final DateIntervalType? dateIntervalType;
  final DateFormat? dateFormat;
  final SfSliderThemeData sliderThemeData;
  final LabelFormatterCallback labelFormatterCallback;
  final TooltipTextFormatterCallback tooltipTextFormatterCallback;
  final SfSliderSemanticFormatterCallback? semanticFormatterCallback;
  final SfDividerShape dividerShape;
  final SfTrackShape trackShape;
  final SfTickShape tickShape;
  final SfTickShape minorTickShape;
  final SfOverlayShape overlayShape;
  final SfThumbShape thumbShape;
  final SfTooltipShape tooltipShape;
  final Widget? thumbIcon;
  final _SfSliderState state;

  @override
  _RenderSliderElement createElement() => _RenderSliderElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSlider(
        min: min,
        max: max,
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        minorTicksPerInterval: minorTicksPerInterval,
        interval: interval,
        stepSize: stepSize,
        stepDuration: stepDuration,
        showTicks: showTicks,
        showLabels: showLabels,
        showDividers: showDividers,
        enableTooltip: enableTooltip,
        shouldAlwaysShowTooltip: shouldAlwaysShowTooltip,
        isInversed: isInversed,
        labelPlacement: labelPlacement,
        edgeLabelPlacement: edgeLabelPlacement,
        numberFormat: numberFormat,
        dateFormat: dateFormat,
        dateIntervalType: dateIntervalType,
        labelFormatterCallback: labelFormatterCallback,
        tooltipTextFormatterCallback: tooltipTextFormatterCallback,
        semanticFormatterCallback: semanticFormatterCallback,
        trackShape: trackShape,
        dividerShape: dividerShape,
        overlayShape: overlayShape,
        thumbShape: thumbShape,
        tickShape: tickShape,
        minorTickShape: minorTickShape,
        tooltipShape: tooltipShape,
        sliderThemeData: sliderThemeData,
        sliderType: sliderType,
        tooltipPosition: tooltipPosition,
        textDirection: Directionality.of(context),
        mediaQueryData: MediaQuery.of(context),
        state: state);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSlider renderObject) {
    renderObject
      ..min = min
      ..max = max
      ..value = value
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeEnd = onChangeEnd
      ..interval = interval
      ..stepSize = stepSize
      ..stepDuration = stepDuration
      ..minorTicksPerInterval = minorTicksPerInterval
      ..showTicks = showTicks
      ..showLabels = showLabels
      ..showDividers = showDividers
      ..enableTooltip = enableTooltip
      ..shouldAlwaysShowTooltip = shouldAlwaysShowTooltip
      ..isInversed = isInversed
      ..labelPlacement = labelPlacement
      ..edgeLabelPlacement = edgeLabelPlacement
      ..numberFormat = numberFormat
      ..dateFormat = dateFormat
      ..dateIntervalType = dateIntervalType
      ..labelFormatterCallback = labelFormatterCallback
      ..tooltipTextFormatterCallback = tooltipTextFormatterCallback
      ..semanticFormatterCallback = semanticFormatterCallback
      ..trackShape = trackShape
      ..dividerShape = dividerShape
      ..overlayShape = overlayShape
      ..thumbShape = thumbShape
      ..tickShape = tickShape
      ..minorTickShape = minorTickShape
      ..tooltipShape = tooltipShape
      ..sliderThemeData = sliderThemeData
      ..tooltipPosition = tooltipPosition
      ..textDirection = Directionality.of(context)
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderSliderElement extends RenderObjectElement {
  _RenderSliderElement(_SliderRenderObjectWidget slider) : super(slider);

  final Map<ChildElements, Element> _slotToChild = <ChildElements, Element>{};

  final Map<Element, ChildElements> _childToSlot = <Element, ChildElements>{};

  @override
  _SliderRenderObjectWidget get widget =>
      // ignore: avoid_as
      super.widget as _SliderRenderObjectWidget;

  @override
  // ignore: avoid_as
  _RenderSlider get renderObject => super.renderObject as _RenderSlider;

  void _updateChild(Widget? widget, ChildElements slot) {
    final Element? oldChild = _slotToChild[slot];
    final Element? newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      _childToSlot.remove(oldChild);
      _slotToChild.remove(slot);
    }
    if (newChild != null) {
      _slotToChild[slot] = newChild;
      _childToSlot[newChild] = slot;
    }
  }

  void _updateRenderObject(RenderObject? child, ChildElements slot) {
    switch (slot) {
      case ChildElements.startThumbIcon:
        // ignore: avoid_as
        renderObject.thumbIcon = child as RenderBox?;
        break;
      case ChildElements.endThumbIcon:
        break;
      case ChildElements.child:
        break;
    }
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    _slotToChild.values.forEach(visitor);
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _updateChild(widget.thumbIcon, ChildElements.startThumbIcon);
  }

  @override
  void update(_SliderRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.thumbIcon, ChildElements.startThumbIcon);
  }

  @override
  void insertRenderObjectChild(RenderObject child, ChildElements slotValue) {
    assert(child is RenderBox);
    final ChildElements slot = slotValue;
    _updateRenderObject(child, slot);
    assert(renderObject.childToSlot.keys.contains(child));
    assert(renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void removeRenderObjectChild(RenderObject child, ChildElements slot) {
    assert(child is RenderBox);
    assert(renderObject.childToSlot.keys.contains(child));
    _updateRenderObject(null, renderObject.childToSlot[child]!);
    assert(!renderObject.childToSlot.keys.contains(child));
    assert(!renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false, 'not reachable');
  }
}

class _RenderSlider extends RenderBaseSlider implements MouseTrackerAnnotation {
  _RenderSlider({
    required dynamic min,
    required dynamic max,
    required dynamic value,
    required ValueChanged<dynamic>? onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
    required double? interval,
    required double? stepSize,
    required SliderStepDuration? stepDuration,
    required int minorTicksPerInterval,
    required bool showTicks,
    required bool showLabels,
    required bool showDividers,
    required bool enableTooltip,
    required bool shouldAlwaysShowTooltip,
    required bool isInversed,
    required LabelPlacement labelPlacement,
    required EdgeLabelPlacement edgeLabelPlacement,
    required NumberFormat numberFormat,
    required DateFormat? dateFormat,
    required DateIntervalType? dateIntervalType,
    required LabelFormatterCallback labelFormatterCallback,
    required TooltipTextFormatterCallback tooltipTextFormatterCallback,
    required SfSliderSemanticFormatterCallback? semanticFormatterCallback,
    required SfTrackShape trackShape,
    required SfDividerShape dividerShape,
    required SfOverlayShape overlayShape,
    required SfThumbShape thumbShape,
    required SfTickShape tickShape,
    required SfTickShape minorTickShape,
    required SfTooltipShape tooltipShape,
    required SfSliderThemeData sliderThemeData,
    required SliderType sliderType,
    required SliderTooltipPosition? tooltipPosition,
    required TextDirection textDirection,
    required MediaQueryData mediaQueryData,
    required _SfSliderState state,
  })  : _state = state,
        _value = value,
        _semanticFormatterCallback = semanticFormatterCallback,
        _onChanged = onChanged,
        super(
          min: min,
          max: max,
          sliderType: sliderType,
          interval: interval,
          stepSize: stepSize,
          stepDuration: stepDuration,
          minorTicksPerInterval: minorTicksPerInterval,
          showTicks: showTicks,
          showLabels: showLabels,
          showDividers: showDividers,
          enableTooltip: enableTooltip,
          shouldAlwaysShowTooltip: shouldAlwaysShowTooltip,
          isInversed: isInversed,
          labelPlacement: labelPlacement,
          edgeLabelPlacement: edgeLabelPlacement,
          numberFormat: numberFormat,
          dateFormat: dateFormat,
          dateIntervalType: dateIntervalType,
          labelFormatterCallback: labelFormatterCallback,
          tooltipTextFormatterCallback: tooltipTextFormatterCallback,
          trackShape: trackShape,
          dividerShape: dividerShape,
          overlayShape: overlayShape,
          thumbShape: thumbShape,
          tickShape: tickShape,
          minorTickShape: minorTickShape,
          tooltipShape: tooltipShape,
          tooltipPosition: tooltipPosition,
          sliderThemeData: sliderThemeData,
          textDirection: textDirection,
          mediaQueryData: mediaQueryData,
        ) {
    final GestureArenaTeam team = GestureArenaTeam();
    if (sliderType == SliderType.horizontal) {
      horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
        ..team = team
        ..onStart = _onDragStart
        ..onUpdate = _onDragUpdate
        ..onEnd = _onDragEnd
        ..onCancel = _onDragCancel;
    }

    if (sliderType == SliderType.vertical) {
      verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
        ..team = team
        ..onStart = _onVerticalDragStart
        ..onUpdate = _onVerticalDragUpdate
        ..onEnd = _onVerticalDragEnd
        ..onCancel = _onVerticalDragCancel;
    }

    tapGestureRecognizer = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _onTapDown
      ..onTapUp = _onTapUp;

    _overlayAnimation = CurvedAnimation(
        parent: _state.overlayController, curve: Curves.fastOutSlowIn);

    _stateAnimation = CurvedAnimation(
        parent: _state.stateController, curve: Curves.easeInOut);

    _tooltipAnimation = CurvedAnimation(
        parent: _state.tooltipAnimationController, curve: Curves.fastOutSlowIn);

    if (shouldAlwaysShowTooltip) {
      _state.tooltipAnimationController.value = 1;
    }

    updateTextPainter();

    if (isDateTime) {
      _valueInMilliseconds =
          // ignore: avoid_as
          (value as DateTime).millisecondsSinceEpoch.toDouble();
    }
  }

  final _SfSliderState _state;

  late Animation<double> _overlayAnimation;

  late Animation<double> _stateAnimation;

  late Animation<double> _tooltipAnimation;

  late bool _validForMouseTracker;

  late dynamic _newValue;

  ValueChanged<dynamic>? onChangeStart;

  ValueChanged<dynamic>? onChangeEnd;

  double? _valueInMilliseconds;

  final Map<ChildElements, RenderBox> slotToChild =
      <ChildElements, RenderBox>{};

  final Map<RenderBox, ChildElements> childToSlot =
      <RenderBox, ChildElements>{};

  dynamic get value => _value;
  dynamic _value;

  set value(dynamic value) {
    if (_value == value) {
      return;
    }

    _value = value;
    if (isDateTime) {
      _valueInMilliseconds =
          // ignore: avoid_as
          (_value as DateTime).millisecondsSinceEpoch.toDouble();
    }
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  ValueChanged<dynamic>? get onChanged => _onChanged;
  ValueChanged<dynamic>? _onChanged;

  set onChanged(ValueChanged<dynamic>? value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      if (isInteractive) {
        _state.stateController.forward();
      } else {
        _state.stateController.reverse();
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  SfSliderSemanticFormatterCallback? get semanticFormatterCallback =>
      _semanticFormatterCallback;
  SfSliderSemanticFormatterCallback? _semanticFormatterCallback;

  set semanticFormatterCallback(SfSliderSemanticFormatterCallback? value) {
    if (_semanticFormatterCallback == value) {
      return;
    }
    _semanticFormatterCallback = value;
    markNeedsSemanticsUpdate();
  }

  RenderBox? get thumbIcon => _thumbIcon;
  RenderBox? _thumbIcon;

  set thumbIcon(RenderBox? value) {
    _thumbIcon = _updateChild(_thumbIcon, value, ChildElements.startThumbIcon);
  }

  @override
  bool get isInteractive => onChanged != null;

  double get actualValue =>
      // ignore: avoid_as
      (isDateTime ? _valueInMilliseconds : _value.toDouble()) as double;

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get children sync* {
    if (_thumbIcon != null) {
      yield _thumbIcon!;
    }
  }

  dynamic get _increasedValue {
    return getNextSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  dynamic get _decreasedValue {
    return getPrevSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  RenderBox? _updateChild(
      RenderBox? oldChild, RenderBox? newChild, ChildElements slot) {
    if (oldChild != null) {
      dropChild(oldChild);
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      childToSlot[newChild] = slot;
      slotToChild[slot] = newChild;
      adoptChild(newChild);
    }
    return newChild;
  }

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    mainAxisOffset = sliderType == SliderType.horizontal
        ? globalToLocal(details.globalPosition).dx
        : globalToLocal(details.globalPosition).dy;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onDragStart(DragStartDetails details) {
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _beginInteraction();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dx;
    _updateValue();
    markNeedsPaint();
  }

  void _onDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onDragCancel() {
    _endInteraction();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _beginInteraction();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _updateValue();
    markNeedsPaint();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onVerticalDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    isInteractionEnd = false;
    onChangeStart?.call(_value);
    _state.overlayController.forward();
    if (enableTooltip) {
      willDrawTooltip = true;
      _state.tooltipAnimationController.forward();
      _state.tooltipDelayTimer?.cancel();
      _state.tooltipDelayTimer = Timer(const Duration(milliseconds: 500), () {
        _state.tooltipDelayTimer = null;
        if (isInteractionEnd &&
            willDrawTooltip &&
            _state.tooltipAnimationController.status ==
                AnimationStatus.completed &&
            !shouldAlwaysShowTooltip) {
          _state.tooltipAnimationController.reverse();
        }
      });
    }

    _updateValue();
    markNeedsPaint();
  }

  void _updateValue() {
    final double factor = getFactorFromCurrentPosition();
    final double valueFactor = lerpDouble(actualMin, actualMax, factor)!;
    _newValue = getActualValue(valueInDouble: valueFactor);

    if (_newValue != _value) {
      onChanged!(_newValue);
    }
  }

  void _endInteraction() {
    if (!isInteractionEnd) {
      _state.overlayController.reverse();
      if (enableTooltip &&
          _state.tooltipDelayTimer == null &&
          !shouldAlwaysShowTooltip) {
        _state.tooltipAnimationController.reverse();
        if (_state.tooltipAnimationController.status ==
            AnimationStatus.dismissed) {
          willDrawTooltip = false;
        }
      }

      currentPointerType = PointerType.up;
      isInteractionEnd = true;
      onChangeEnd?.call(_newValue);
      markNeedsPaint();
    }
  }

  void _handleTooltipAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      willDrawTooltip = false;
    }
  }

  void _drawTooltip(PaintingContext context, Offset thumbCenter, Offset offset,
      Offset actualTrackOffset, Rect trackRect) {
    if (willDrawTooltip || shouldAlwaysShowTooltip) {
      final Paint paint = Paint()
        ..color = sliderThemeData.tooltipBackgroundColor!
        ..style = PaintingStyle.fill
        ..strokeWidth = 0;

      final dynamic actualText = sliderType == SliderType.horizontal
          ? getValueFromPosition(thumbCenter.dx - offset.dx)
          : getValueFromPosition(trackRect.bottom - thumbCenter.dy);
      final String tooltipText = tooltipTextFormatterCallback(
          actualText, getFormattedText(actualText));
      final TextSpan textSpan =
          TextSpan(text: tooltipText, style: sliderThemeData.tooltipTextStyle);
      textPainter.text = textSpan;
      textPainter.layout();

      tooltipShape.paint(context, thumbCenter,
          Offset(actualTrackOffset.dx, tooltipStartY), textPainter,
          parentBox: this,
          sliderThemeData: sliderThemeData,
          paint: paint,
          animation: _tooltipAnimation,
          trackRect: trackRect);
    }
  }

  void increaseAction() {
    if (isInteractive) {
      onChanged!(_increasedValue);
    }
  }

  void decreaseAction() {
    if (isInteractive) {
      onChanged!(_decreasedValue);
    }
  }

  void _handleEnter(PointerEnterEvent event) {
    _state.overlayController.forward();
    if (enableTooltip) {
      willDrawTooltip = true;
      _state.tooltipAnimationController.forward();
    }
  }

  void _handleExit(PointerExitEvent event) {
    // Ensuring whether the thumb is drag or move
    // not needed to call controller's reverse.
    if (_state.mounted && currentPointerType != PointerType.move) {
      _state.overlayController.reverse();
      if (enableTooltip && !shouldAlwaysShowTooltip) {
        _state.tooltipAnimationController.reverse();
      }
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    children.forEach(visitor);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
    _overlayAnimation.addListener(markNeedsPaint);
    _stateAnimation.addListener(markNeedsPaint);
    _tooltipAnimation.addListener(markNeedsPaint);
    _tooltipAnimation.addStatusListener(_handleTooltipAnimationStatusChange);
    for (final RenderBox child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    _overlayAnimation.removeListener(markNeedsPaint);
    _stateAnimation.removeListener(markNeedsPaint);
    _tooltipAnimation.removeListener(markNeedsPaint);
    _tooltipAnimation.removeStatusListener(_handleTooltipAnimationStatusChange);
    super.detach();
    for (final RenderBox child in children) {
      child.detach();
    }
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener get onEnter => _handleEnter;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  @override
  void performLayout() {
    super.performLayout();
    final BoxConstraints contentConstraints = BoxConstraints.tightFor(
        width: actualThumbSize.width, height: actualThumbSize.height);
    _thumbIcon?.layout(contentConstraints, parentUsesSize: true);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position) && isInteractive) {
      if (_thumbIcon != null &&
          ((_thumbIcon!.parentData! as BoxParentData).offset & _thumbIcon!.size)
              .contains(position)) {
        final Offset center = _thumbIcon!.size.center(Offset.zero);
        result.addWithRawTransform(
          transform: MatrixUtils.forceToPoint(center),
          position: position,
          hitTest: (BoxHitTestResult result, Offset? position) {
            return thumbIcon!.hitTest(result, position: center);
          },
        );
      }
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset actualTrackOffset = sliderType == SliderType.horizontal
        ? Offset(
            offset.dx,
            offset.dy +
                (size.height - actualHeight) / 2 +
                trackOffset.dy -
                maxTrackHeight / 2)
        : Offset(
            offset.dx +
                (size.width - actualHeight) / 2 +
                trackOffset.dx -
                maxTrackHeight / 2,
            offset.dy);

    // Drawing track.
    final Rect trackRect =
        trackShape.getPreferredRect(this, sliderThemeData, actualTrackOffset);
    final double thumbPosition = getFactorFromValue(actualValue) *
        (sliderType == SliderType.horizontal
            ? trackRect.width
            : trackRect.height);
    final Offset thumbCenter = sliderType == SliderType.horizontal
        ? Offset(trackRect.left + thumbPosition, trackRect.center.dy)
        : Offset(trackRect.center.dx, trackRect.bottom - thumbPosition);

    trackShape.paint(context, actualTrackOffset, thumbCenter, null, null,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        activePaint: null,
        inactivePaint: null);

    if (showLabels || showTicks || showDividers) {
      drawLabelsTicksAndDividers(context, trackRect, offset, thumbCenter, null,
          null, _stateAnimation, _value, null);
    }

    // Drawing overlay.
    overlayShape.paint(context, thumbCenter,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        animation: _overlayAnimation,
        thumb: null,
        paint: null);

    if (_thumbIcon != null) {
      (_thumbIcon!.parentData! as BoxParentData).offset = thumbCenter -
          Offset(_thumbIcon!.size.width / 2, _thumbIcon!.size.height / 2) -
          offset;
    }
    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: _thumbIcon,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: null,
        paint: null);

    _drawTooltip(context, thumbCenter, offset, actualTrackOffset, trackRect);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.textDirection = textDirection;
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
      if (semanticFormatterCallback != null) {
        config.value = semanticFormatterCallback!(value);
        config.increasedValue = semanticFormatterCallback!(_increasedValue);
        config.decreasedValue = semanticFormatterCallback!(_decreasedValue);
      } else {
        config.value = '$value';
        config.increasedValue = '$_increasedValue';
        config.decreasedValue = '$_decreasedValue';
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        'thumbSize', thumbShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'activeDividerSize',
        dividerShape
            .getPreferredSize(sliderThemeData, isActive: true)
            .toString()));
    properties.add(StringProperty(
        'inactiveDividerSize',
        dividerShape
            .getPreferredSize(sliderThemeData, isActive: false)
            .toString()));
    properties.add(StringProperty('overlaySize',
        overlayShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty(
        'tickSize', tickShape.getPreferredSize(sliderThemeData).toString()));
    properties.add(StringProperty('minorTickSize',
        minorTickShape.getPreferredSize(sliderThemeData).toString()));
  }
}
