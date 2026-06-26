part of '../../main.dart';

class HotelListScreen extends StatefulWidget { const HotelListScreen({super.key}); @override State<HotelListScreen> createState() => _HotelListScreenState(); }
class _HotelListScreenState extends State<HotelListScreen> {
  late Future<List<AppHotel>> futureHotels;
  @override void initState(){ super.initState(); futureHotels = AppApi.getHotels(); }
  @override Widget build(BuildContext context)=> Scaffold(appBar: AppBar(title: const Text('Alojamientos')), body: FutureBuilder<List<AppHotel>>(future: futureHotels, builder:(context,snapshot){
    if(snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
    if(snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: ()=> setState(()=> futureHotels = AppApi.getHotels()));
    final hotels=snapshot.data??[];
    return ListView.separated(padding: const EdgeInsets.all(16), itemCount: hotels.length, separatorBuilder: (_,__)=> const SizedBox(height:10), itemBuilder:(context,index){ final hotel=hotels[index]; return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(hotel.name, style: Theme.of(context).textTheme.titleMedium), Text(hotel.location), Text(hotel.type), Text('Desde S/ ${hotel.basePrice.toStringAsFixed(2)}')]))); });
  }));
}
