import 'package:dio/dio.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/average.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average/data_average_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/average_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/data_avg_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/average_period/param_period.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/data_correlation_matrix.dart';
import 'package:frontend_water_quality/domain/models/analysis/correlation/param_correlation.dart';
import 'package:frontend_water_quality/domain/models/analysis/parameters.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_all.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/data_pred_sensor.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/param_prediction.dart';
import 'package:frontend_water_quality/domain/models/analysis/period/prediction.dart';

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

  Future<List<PredictionSensor>> getPredictions(
    String workspaceId,
    String meterId,
    String token,
  ) async {
    return [
      PredictionSensor(
        id: "594b9939-872b-4569-3ca7-ace2c774adfa",
        createdAt: DateTime.tryParse("2025-09-27 01:44:26.855857"),
        parameters: ParamPrediction(
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          endDate: DateTime.tryParse("2025-09-06 23:59:59"),
          periodType: "years",
          ahead: 10,
          sensor: "tds",
        ),
        data: DataPredSensor(
          data: TimeSeriesData(
            labels: [
              DateTime.tryParse("2025-01-01"),
            ],
            values: [
              247.03643649342865,
            ],
          ),
          pred: TimeSeriesData(
            labels: [
              DateTime.tryParse("2026-01-01"),
              DateTime.tryParse("2027-01-01"),
              DateTime.tryParse("2028-01-01"),
              DateTime.tryParse("2029-01-01"),
              DateTime.tryParse("2030-01-01"),
              DateTime.tryParse("2031-01-01"),
              DateTime.tryParse("2032-01-01"),
              DateTime.tryParse("2033-01-01"),
              DateTime.tryParse("2034-01-01"),
              DateTime.tryParse("2035-01-01"),
            ],
            values: [
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
              247.03643649342865,
            ],
          ),
          sensor: "tds",
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        status: "saved",
        type: "prediction",
        updatedAt: DateTime.tryParse("2025-09-27 01:44:32.305679"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),
      PredictionSensor(
        id: "937b237d-1848-fc2a-965a-3e8e6b86e463",
        createdAt: DateTime.tryParse("2025-09-21 23:19:07.158027"),
        parameters: ParamPrediction(
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          endDate: DateTime.tryParse("2025-09-06 23:59:59"),
          periodType: "days",
          ahead: 20,
          sensor: "tds",
        ),
        data: DataPredSensor(
          data: TimeSeriesData(
            labels: [
              DateTime.tryParse("2025-08-24"),
              DateTime.tryParse("2025-08-25"),
              DateTime.tryParse("2025-08-30"),
              DateTime.tryParse("2025-08-31"),
              DateTime.tryParse("2025-09-01"),
              DateTime.tryParse("2025-09-02"),
              DateTime.tryParse("2025-09-03"),
              DateTime.tryParse("2025-09-05"),
              DateTime.tryParse("2025-09-06"),
            ],
            values: [
              293.6279381023432,
              246.660479924047,
              80.09636930034317,
              224.50725130469556,
              244.64886646059884,
              259.73356740443575,
              253.83217132315403,
              247.02049939714095,
              248.76665038446507,
            ],
          ),
          pred: TimeSeriesData(
            labels: [
              DateTime.tryParse("2025-09-07"),
              DateTime.tryParse("2025-09-08"),
              DateTime.tryParse("2025-09-09"),
              DateTime.tryParse("2025-09-10"),
              DateTime.tryParse("2025-09-11"),
              DateTime.tryParse("2025-09-12"),
              DateTime.tryParse("2025-09-13"),
              DateTime.tryParse("2025-09-14"),
              DateTime.tryParse("2025-09-15"),
              DateTime.tryParse("2025-09-16"),
              DateTime.tryParse("2025-09-17"),
              DateTime.tryParse("2025-09-18"),
              DateTime.tryParse("2025-09-19"),
              DateTime.tryParse("2025-09-20"),
              DateTime.tryParse("2025-09-21"),
              DateTime.tryParse("2025-09-22"),
              DateTime.tryParse("2025-09-23"),
              DateTime.tryParse("2025-09-24"),
              DateTime.tryParse("2025-09-25"),
              DateTime.tryParse("2025-09-26"),
            ],
            values: [
              226.30816675884134,
              225.23712722829563,
              224.1660876977499,
              223.0950481672042,
              222.0240086366585,
              220.95296910611276,
              219.88192957556706,
              218.81089004502132,
              217.73985051447562,
              216.66881098392992,
              215.59777145338418,
              214.52673192283848,
              213.45569239229275,
              212.38465286174704,
              211.3136133312013,
              210.2425738006556,
              209.17153427010987,
              208.10049473956417,
              207.02945520901847,
              205.95841567847273,
            ],
          ),
          sensor: "tds",
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        status: "saved",
        type: "prediction",
        updatedAt: DateTime.tryParse("2025-09-21 23:19:10.709722"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),
      PredictionSensor(
        id: "fc54304e-ec77-ff39-d186-65f402709fd6",
        createdAt: DateTime.tryParse("2025-09-09 22:06:45.115083"),
        parameters: ParamPrediction(
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          endDate: DateTime.tryParse("2025-09-06 23:59:59"),
          periodType: "days",
          ahead: 15,
        ),
        data: DataPredAll(
          data: WaterQualityData(
            conductivity: [
              1751.5508614138764,
              1463.2068995159677,
              273.61925473609887,
              1589.4497482861489,
              1510.518036930298,
              1527.1256968204887,
              1491.135887038546,
              1517.591363425429,
              1497.9570268255222,
            ],
            labels: [
              DateTime.tryParse("2025-08-24"),
              DateTime.tryParse("2025-08-25"),
              DateTime.tryParse("2025-08-30"),
              DateTime.tryParse("2025-08-31"),
              DateTime.tryParse("2025-09-01"),
              DateTime.tryParse("2025-09-02"),
              DateTime.tryParse("2025-09-03"),
              DateTime.tryParse("2025-09-05"),
              DateTime.tryParse("2025-09-06"),
            ],
            ph: [
              6.881599277625872,
              5.073461016252853,
              5.1320649935862,
              4.810178771168357,
              5.002060183823277,
              5.257706887677279,
              5.079627985236037,
              4.990210856104803,
              5.042830815009177,
            ],
            tds: [
              293.6279381023432,
              246.660479924047,
              80.09636930034317,
              224.50725130469556,
              244.64886646059884,
              259.73356740443575,
              253.83217132315403,
              247.02049939714095,
              248.76665038446507,
            ],
            temperature: [
              14.081749100543089,
              17.82765500501116,
              14.447067960248967,
              17.027720716245327,
              17.616182766508082,
              16.600619949336803,
              17.24566786567737,
              17.71503340525113,
              17.10972410871653,
            ],
            turbidity: [
              25.582507095791588,
              24.540574842973914,
              5.965900387487036,
              25.84735196549286,
              24.444992074429603,
              25.393911736229533,
              25.202616663412307,
              24.762179741042765,
              24.629951702687258,
            ],
          ),
          pred: WaterQualityData(
            conductivity: [
              1371.764596334405,
              1367.001261714013,
              1362.2379270936212,
              1357.4745924732292,
              1352.7112578528372,
              1347.9479232324454,
              1343.1845886120534,
              1338.4212539916614,
              1333.6579193712696,
              1328.8945847508776,
              1324.1312501304856,
              1319.3679155100936,
              1314.6045808897018,
              1309.8412462693097,
              1305.077911648918,
              1300.314577028526,
              1295.551242408134,
              1290.787907787742,
              1286.0245731673501,
              1281.261238546958,
            ],
            labels: [
              DateTime.tryParse("2025-09-07"),
              DateTime.tryParse("2025-09-08"),
              DateTime.tryParse("2025-09-09"),
              DateTime.tryParse("2025-09-10"),
              DateTime.tryParse("2025-09-11"),
              DateTime.tryParse("2025-09-12"),
              DateTime.tryParse("2025-09-13"),
              DateTime.tryParse("2025-09-14"),
              DateTime.tryParse("2025-09-15"),
              DateTime.tryParse("2025-09-16"),
              DateTime.tryParse("2025-09-17"),
              DateTime.tryParse("2025-09-18"),
              DateTime.tryParse("2025-09-19"),
              DateTime.tryParse("2025-09-20"),
              DateTime.tryParse("2025-09-21"),
              DateTime.tryParse("2025-09-22"),
              DateTime.tryParse("2025-09-23"),
              DateTime.tryParse("2025-09-24"),
              DateTime.tryParse("2025-09-25"),
              DateTime.tryParse("2025-09-26"),
            ],
            ph: [
              4.714780444355444,
              4.631388775609153,
              4.547997106862863,
              4.464605438116572,
              4.381213769370282,
              4.297822100623991,
              4.2144304318777,
              4.13103876313141,
              4.04764709438512,
              3.9642554256388287,
              3.880863756892538,
              3.7974720881462476,
              3.714080419399957,
              3.6306887506536665,
              3.5472970819073755,
              3.463905413161085,
              3.3805137444147944,
              3.297122075668504,
              3.2137304069222132,
              3.1303387381759227,
            ],
            tds: [
              226.30816675884134,
              225.23712722829563,
              224.1660876977499,
              223.0950481672042,
              222.0240086366585,
              220.95296910611276,
              219.88192957556706,
              218.81089004502132,
              217.73985051447562,
              216.66881098392992,
              215.59777145338418,
              214.52673192283848,
              213.45569239229275,
              212.38465286174704,
              211.3136133312013,
              210.2425738006556,
              209.17153427010987,
              208.10049473956417,
              207.02945520901847,
              205.95841567847273,
            ],
            temperature: [
              17.487231825975353,
              17.620226059703626,
              17.753220293431898,
              17.886214527160167,
              18.01920876088844,
              18.15220299461671,
              18.28519722834498,
              18.418191462073253,
              18.551185695801525,
              18.684179929529794,
              18.817174163258066,
              18.95016839698634,
              19.083162630714607,
              19.21615686444288,
              19.349151098171152,
              19.48214533189942,
              19.615139565627693,
              19.748133799355966,
              19.881128033084234,
              20.014122266812507,
            ],
            turbidity: [
              23.244699429406552,
              23.29353233725331,
              23.342365245100073,
              23.39119815294683,
              23.440031060793594,
              23.488863968640352,
              23.537696876487114,
              23.586529784333873,
              23.635362692180635,
              23.684195600027394,
              23.733028507874156,
              23.78186141572092,
              23.830694323567677,
              23.87952723141444,
              23.928360139261198,
              23.97719304710796,
              24.02602595495472,
              24.07485886280148,
              24.12369177064824,
              24.172524678495,
            ],
          ),
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        status: "saved",
        type: "prediction",
        updatedAt: DateTime.tryParse("2025-09-09 22:08:43.172239"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      )
    ];
  }

  Future<List<Correlation>> getCorrelations(
    String workspaceId,
    String meterId,
    String token,
  ) async {
    // Lista de ejemplos de correlación
    return [
      // Ejemplo 1: Correlación de TDS, pH y Conductividad
      Correlation(
        id: "491733b4-9505-9103-7bce-3f41c24428ac",
        createdAt: DateTime.tryParse("2025-09-09 22:09:04.682305"),
        data: DataCorrelationMatrix(
          matrix: [
            [1, 0.35028823994785213, 0.9730369856825265],
            [0.35028823994785213, 1, 0.24129311139024442],
            [0.9730369856825265, 0.24129311139024442, 1],
          ],
          method: "pearson",
          sensors: ["tds", "ph", "conductivity"],
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        parameters: ParamCorrelation(
          endDate: DateTime.tryParse("2025-09-06 23:59:59"),
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          periodType: "days",
          method: "pearson",
          sensors: ["tds", "ph", "conductivity"],
        ),
        status: "saved",
        type: "correlation",
        updatedAt: DateTime.tryParse("2025-09-09 22:09:46.782241"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),

      // Ejemplo 2: Correlación de pH y Temperatura
      Correlation(
        id: "9e0fddc1-c16b-b41c-c4a4-22b25d1e6a45",
        createdAt: DateTime.tryParse("2025-09-29 22:47:47.429188"),
        data: DataCorrelationMatrix(
          matrix: [
            [1, -0.3115168260680026],
            [-0.3115168260680026, 1],
          ],
          method: "pearson",
          sensors: ["ph", "temperature"],
        ),
        error: "",
        meterId: "-OVnW46EjvIYWdpO8zPz",
        parameters: ParamCorrelation(
          endDate: DateTime.tryParse("2025-09-26 23:59:59"),
          startDate: DateTime.tryParse("2025-04-01 00:00:00"),
          periodType: "days",
          method: "pearson",
          sensors: ["ph", "temperature"],
        ),
        status: "saved",
        type: "correlation",
        updatedAt: DateTime.tryParse("2025-09-29 22:47:51.331493"),
        workspaceId: "-OV6KJon4LkGwCw8pNvh",
      ),
    ];
  }
}
