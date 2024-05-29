package backend.lezaczek.Config;

import backend.lezaczek.Model.News;
import backend.lezaczek.Repositories.NewsRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.util.List;

@Configuration
public class NewsConfig {
    //this code inserts data on every run, so I commented that for now

//    @Bean
//    CommandLineRunner commandLineRunner(NewsRepository repository){
//        return args -> {
//            News weeia = new News(
//                    2,
//                    "Dni wydziału EEIA",
//                    "Najlepsze wydarzenie na PŁ",
//                    "WEEIA",
//                    LocalDate.of(2024, Month.APRIL, 29),
//                    LocalDate.of(2024, Month.MAY,31),
//                    LocalTime.of(8,30),
//                    LocalTime.of(16,0)
//            );
//            News aka = new News(
//                    2,
//                    "Targi pracy",
//                    "Najlepsze wydarzenie na hali EXPO",
//                    "Hala EXPO al. Politechniki",
//                    LocalDate.of(2024, Month.APRIL, 4),
//                    LocalDate.of(2024, Month.JUNE,3),
//                    LocalTime.of(8,0),
//                    LocalTime.of(18,0)
//            );
//            repository.saveAll(
//                    List.of(weeia, aka)
//            );
//        };
//    }
}
