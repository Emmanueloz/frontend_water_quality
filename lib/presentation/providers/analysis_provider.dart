import 'package:dio/dio.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';

class AnalysisProvider {
  final Dio _dio;

  AnalysisProvider(this._dio);

  Future<List<Average>> getAverage(
      String workspaceId, String meterId, String token) async {
    return [
      Average(
        id: "05f6f710-4483-c011-26f9-6d110cd555af",
        workspaceId: workspaceId,
        meterId: meterId,
        parameters: Parameters(
          startDate: DateTime.tryParse("2025-08-20 00:00:00"),
          endDate: DateTime.tryParse("2025-09-08 21:53:00"),
          sensor: "ph",
        ),
        data: DataAverageSensor(
          sensor: "ph",
          stats: Stats(
            average: 5.047702021503715,
            max: 15,
            min: 0.0007895208644093099,
          ),
        ),
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-09 21:52:39.387462"),
        updatedAt: DateTime.tryParse("2025-09-09 21:53:04.135930"),
      ),
      Average(
        id: "4d9405be-1960-efe3-a0e1-0f2bd3ab8dec",
        workspaceId: workspaceId,
        meterId: meterId,
        parameters: Parameters(
          startDate: DateTime.tryParse("2025-08-20 00:00:00"),
          endDate: DateTime.tryParse("2025-09-18 21:53:00"),
        ),
        data: DataAverageAll(
          result: [
            ResultAverage(
              average: 1478.4157853094275,
              max: 3500,
              min: 0.014457053746808057,
              sensor: "conductivity",
            ),
            ResultAverage(
              average: 5.06579072043262,
              max: 15,
              min: 0.0001220770079179978,
              sensor: "ph",
            ),
            ResultAverage(
              average: 17.399204175308967,
              max: 38,
              min: 0.0006186792622814297,
              sensor: "temperature",
            ),
            ResultAverage(
              average: 245.34736451593616,
              max: 620,
              min: 0,
              sensor: "tds",
            ),
            ResultAverage(
              average: 24.488921922661323,
              max: 70,
              min: 0.0010722281333697126,
              sensor: "turbidity",
            ),
          ],
        ),
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-17 01:58:50.086345"),
        updatedAt: DateTime.tryParse("2025-09-17 01:58:53.998612"),
      ),
      Average(
        id: "9f7c950c-f75e-7014-e360-fc4dc3fceeb8",
        workspaceId: workspaceId,
        meterId: meterId,
        parameters: Parameters(
          startDate: DateTime.tryParse("2025-08-20 00:00:00"),
          endDate: DateTime.tryParse("2025-09-08 21:53:00"),
          sensor: "tds",
        ),
        data: DataAverageSensor(
          sensor: "tds",
          stats: Stats(
            average: 247.03643649342865,
            max: 620,
            min: 0,
          ),
        ),
        status: "saved",
        type: "average",
        createdAt: DateTime.tryParse("2025-09-09 21:53:35.501831"),
        updatedAt: DateTime.tryParse("2025-09-09 21:53:38.586538"),
      ),
    ];
  }

  Future<List<AveragePeriod>> getAveragePeriod(
    String workspaceId,
    String meterId,
    String token,
  ) async {
    return [
      // Primer elemento: sensor turbidity
      AveragePeriod(
        id: "2548ad65-0df0-2b8e-27cd-b2fb33a03e38",
        createdAt: DateTime.tryParse("2025-09-20 01:54:39.061947"),
        data: DataAvgSensor(
          averages: [
            AvgValue(
                date: DateTime.tryParse("2025-08-24T00:00:00"),
                value: 25.582507095791588),
            AvgValue(
                date: DateTime.tryParse("2025-08-25T00:00:00"),
                value: 24.540574842973914),
            AvgValue(
                date: DateTime.tryParse("2025-08-26T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-27T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-28T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-29T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-30T00:00:00"),
                value: 5.965900387487036),
            AvgValue(
                date: DateTime.tryParse("2025-08-31T00:00:00"),
                value: 25.84735196549286),
            AvgValue(
                date: DateTime.tryParse("2025-09-01T00:00:00"),
                value: 24.444992074429603),
            AvgValue(
                date: DateTime.tryParse("2025-09-02T00:00:00"),
                value: 25.393911736229533),
            AvgValue(
                date: DateTime.tryParse("2025-09-03T00:00:00"),
                value: 25.202616663412307),
            AvgValue(
                date: DateTime.tryParse("2025-09-04T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-05T00:00:00"),
                value: 24.762179741042765),
            AvgValue(
                date: DateTime.tryParse("2025-09-06T00:00:00"),
                value: 24.629951702687258),
            AvgValue(
                date: DateTime.tryParse("2025-09-07T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-08T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-09T00:00:00"),
                value: 24.877627498101724),
            AvgValue(
                date: DateTime.tryParse("2025-09-10T00:00:00"),
                value: 24.42100257884804),
            AvgValue(
                date: DateTime.tryParse("2025-09-11T00:00:00"),
                value: 24.71942299367222),
            AvgValue(
                date: DateTime.tryParse("2025-09-12T00:00:00"),
                value: 25.19510277564574),
            AvgValue(
                date: DateTime.tryParse("2025-09-13T00:00:00"),
                value: 28.062023108245977),
            AvgValue(
                date: DateTime.tryParse("2025-09-14T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-15T00:00:00"),
                value: 24.96283693252611),
            AvgValue(
                date: DateTime.tryParse("2025-09-16T00:00:00"),
                value: 8.151201698520438),
            AvgValue(
                date: DateTime.tryParse("2025-09-17T00:00:00"),
                value: 21.71175207809505),
            AvgValue(
                date: DateTime.tryParse("2025-09-18T00:00:00"),
                value: 57.260089361202056),
          ],
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        parameters: ParamPeriod(
          endDate: DateTime.tryParse("2025-09-19 23:59:00"),
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          sensor: "turbidity",
          periodType: "days",
        ),
        status: "saved",
        type: "average_period",
        updatedAt: DateTime.tryParse("2025-09-20 01:54:41.598880"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),

      // Segundo elemento: todos los sensores (DataAvgAll)
      AveragePeriod(
        id: "5f39da46-01e3-327a-8f0d-8dbc7ba9f90e",
        createdAt: DateTime.tryParse("2025-09-20 01:55:13.680568"),
        data: DataAvgAll(
          conductivity: SensorSpots(
            labels: [
              DateTime.tryParse("2025-08-31T00:00:00"),
              DateTime.tryParse("2025-09-30T00:00:00"),
            ],
            values: [
              1357.8187320507552,
              1485.800051170245,
            ],
          ),
          ph: SensorSpots(
            labels: [
              DateTime.tryParse("2025-08-31T00:00:00"),
              DateTime.tryParse("2025-09-30T00:00:00"),
            ],
            values: [
              5.089485242838196,
              5.038926807535724,
            ],
          ),
          tds: SensorSpots(
            labels: [
              DateTime.tryParse("2025-08-31T00:00:00"),
              DateTime.tryParse("2025-09-30T00:00:00"),
            ],
            values: [
              231.29920410989263,
              245.5463665926781,
            ],
          ),
          temperature: SensorSpots(
            labels: [
              DateTime.tryParse("2025-08-31T00:00:00"),
              DateTime.tryParse("2025-09-30T00:00:00"),
            ],
            values: [
              17.471170807714017,
              17.403541591870752,
            ],
          ),
          turbidity: SensorSpots(
            labels: [
              DateTime.tryParse("2025-08-31T00:00:00"),
              DateTime.tryParse("2025-09-30T00:00:00"),
            ],
            values: [
              22.85534779101629,
              24.742207417322415,
            ],
          ),
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        parameters: ParamPeriod(
          endDate: DateTime.tryParse("2025-09-19 23:59:00"),
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          sensor: null, // Sin sensor específico
          periodType: "days",
        ),
        status: "saved",
        type: "average_period",
        updatedAt: DateTime.tryParse("2025-09-20 01:55:16.096470"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),

      // Tercer elemento: sensor tds
      AveragePeriod(
        id: "e6d56e11-b94f-09c8-a716-b9c455cadea1",
        createdAt: DateTime.tryParse("2025-09-09 22:04:48.717529"),
        data: DataAvgSensor(
          averages: [
            AvgValue(
                date: DateTime.tryParse("2025-08-24T00:00:00"),
                value: 293.6279381023432),
            AvgValue(
                date: DateTime.tryParse("2025-08-25T00:00:00"),
                value: 246.660479924047),
            AvgValue(
                date: DateTime.tryParse("2025-08-26T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-27T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-28T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-29T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-08-30T00:00:00"),
                value: 80.09636930034317),
            AvgValue(
                date: DateTime.tryParse("2025-08-31T00:00:00"),
                value: 224.50725130469556),
            AvgValue(
                date: DateTime.tryParse("2025-09-01T00:00:00"),
                value: 244.64886646059884),
            AvgValue(
                date: DateTime.tryParse("2025-09-02T00:00:00"),
                value: 259.73356740443575),
            AvgValue(
                date: DateTime.tryParse("2025-09-03T00:00:00"),
                value: 253.83217132315403),
            AvgValue(
                date: DateTime.tryParse("2025-09-04T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-05T00:00:00"),
                value: 247.02049939714095),
            AvgValue(
                date: DateTime.tryParse("2025-09-06T00:00:00"),
                value: 248.76665038446507),
            AvgValue(
                date: DateTime.tryParse("2025-09-07T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-08T00:00:00"), value: null),
            AvgValue(
                date: DateTime.tryParse("2025-09-09T00:00:00"),
                value: 235.89097282617786),
            AvgValue(
                date: DateTime.tryParse("2025-09-10T00:00:00"),
                value: 215.97616463007137),
          ],
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        parameters: ParamPeriod(
          endDate: DateTime.tryParse("2025-09-10 23:59:59"),
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          sensor: "tds",
          periodType: "days",
        ),
        status: "saved",
        type: "average_period",
        updatedAt: DateTime.tryParse("2025-09-09 22:04:52.021149"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),
    ];
  }
}
