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
          averages: [
            AvgAllValue(
              date: DateTime.tryParse("2025-08-24T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1751.5508614138764,
                ph: 6.881599277625872,
                tds: 293.6279381023432,
                temperature: 14.081749100543089,
                turbidity: 25.582507095791588,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-08-25T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1463.2068995159677,
                ph: 5.073461016252853,
                tds: 246.660479924047,
                temperature: 17.82765500501116,
                turbidity: 24.540574842973914,
              ),
            ),
            AvgAllValue(
                date: DateTime.tryParse("2025-08-26T00:00:00"), averages: null),
            AvgAllValue(
                date: DateTime.tryParse("2025-08-27T00:00:00"), averages: null),
            AvgAllValue(
                date: DateTime.tryParse("2025-08-28T00:00:00"), averages: null),
            AvgAllValue(
                date: DateTime.tryParse("2025-08-29T00:00:00"), averages: null),
            AvgAllValue(
              date: DateTime.tryParse("2025-08-30T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 273.61925473609887,
                ph: 5.1320649935862,
                tds: 80.09636930034317,
                temperature: 14.447067960248967,
                turbidity: 5.965900387487036,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-08-31T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1589.4497482861489,
                ph: 4.810178771168357,
                tds: 224.50725130469556,
                temperature: 17.027720716245327,
                turbidity: 25.84735196549286,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-01T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1510.518036930298,
                ph: 5.002060183823277,
                tds: 244.64886646059884,
                temperature: 17.616182766508082,
                turbidity: 24.444992074429603,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-02T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1527.1256968204887,
                ph: 5.257706887677279,
                tds: 259.73356740443575,
                temperature: 16.600619949336803,
                turbidity: 25.393911736229533,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-03T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1491.135887038546,
                ph: 5.079627985236037,
                tds: 253.83217132315403,
                temperature: 17.24566786567737,
                turbidity: 25.202616663412307,
              ),
            ),
            AvgAllValue(
                date: DateTime.tryParse("2025-09-04T00:00:00"), averages: null),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-05T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1517.591363425429,
                ph: 4.990210856104803,
                tds: 247.02049939714095,
                temperature: 17.71503340525113,
                turbidity: 24.762179741042765,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-06T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1497.9570268255222,
                ph: 5.042830815009177,
                tds: 248.76665038446507,
                temperature: 17.10972410871653,
                turbidity: 24.629951702687258,
              ),
            ),
            AvgAllValue(
                date: DateTime.tryParse("2025-09-07T00:00:00"), averages: null),
            AvgAllValue(
                date: DateTime.tryParse("2025-09-08T00:00:00"), averages: null),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-09T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1447.239952790374,
                ph: 5.091090526795671,
                tds: 235.89097282617786,
                temperature: 17.808436815816727,
                turbidity: 24.877627498101724,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-10T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1513.7324784107882,
                ph: 4.9975878933737645,
                tds: 249.62716224335534,
                temperature: 17.420566517828927,
                turbidity: 24.42100257884804,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-11T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1496.9523515588355,
                ph: 5.176914531615461,
                tds: 242.79205549668484,
                temperature: 18.260364216811077,
                turbidity: 24.71942299367222,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-12T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1625.555544166232,
                ph: 5.3655456762677,
                tds: 250.3201087799666,
                temperature: 17.349817251700458,
                turbidity: 25.19510277564574,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-13T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1582.4787392690776,
                ph: 5.1906203784556055,
                tds: 213.5232112415689,
                temperature: 18.09847526835273,
                turbidity: 28.062023108245977,
              ),
            ),
            AvgAllValue(
                date: DateTime.tryParse("2025-09-14T00:00:00"), averages: null),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-15T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1476.7607564114141,
                ph: 4.586194417238011,
                tds: 238.92282944799155,
                temperature: 17.519939876878393,
                turbidity: 24.96283693252611,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-16T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 450.82637324813265,
                ph: 5.230461052582229,
                tds: 107.77375287992963,
                temperature: 14.321727964472679,
                turbidity: 8.151201698520438,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-17T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 1267.5986149519617,
                ph: 5.137350364736088,
                tds: 218.64996399917965,
                temperature: 16.7350774298995,
                turbidity: 21.71175207809505,
              ),
            ),
            AvgAllValue(
              date: DateTime.tryParse("2025-09-18T00:00:00"),
              averages: AvgAllSensors(
                conductivity: 378.20891478132944,
                ph: 4.042869094839324,
                tds: 118.41779655684859,
                temperature: 15.007787681081641,
                turbidity: 57.260089361202056,
              ),
            ),
          ],
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
