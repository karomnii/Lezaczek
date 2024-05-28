package backend.lezaczek.Services;

import backend.lezaczek.Model.News;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.util.List;

@Service
public class NewsService {
    public List<News> getNews() {
        return List.of(
                new News(
                        1,
                        1,
                        "Dni wydziału EEIA",
                        "Najlepsze wydarzenie na PŁ",
                        "WEEIA",
                        LocalDate.of(2024, Month.APRIL, 29),
                        LocalDate.of(2024, Month.MAY,31),
                        LocalTime.of(8,30),
                        LocalTime.of(16,0)
                )
        );
    }
}
