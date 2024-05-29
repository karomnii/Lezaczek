package backend.lezaczek.Services;

import backend.lezaczek.Model.News;
import backend.lezaczek.Repositories.NewsRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class NewsService {
    private final NewsRepository newsRepository;

    @Autowired
    public NewsService(NewsRepository newsRepository) {
        this.newsRepository = newsRepository;
    }

    public List<News> getNews() {
        return newsRepository.findAll();
    }

    public void addNews(News news) {
        Optional<News> newsByName = newsRepository.findByName(news.getName());
        if(newsByName.isPresent()){
            throw new IllegalStateException("News already exists");
        }
        newsRepository.save(news);
    }

    public void deleteNews(Long newsId) {
        boolean exists = newsRepository.existsById(newsId);
        if(!exists){
            throw new IllegalStateException("News " + newsId + " doesn't exist");
        }
        newsRepository.deleteById(newsId);
    }

    @Transactional
    public void updateNews(Long newsId, String name, String description, LocalDate dateOfEvent, String place, LocalTime startingTime, LocalTime endingTime) {
        News news = newsRepository.findById(newsId).orElseThrow(() ->new IllegalStateException("News " + newsId + " doesn't exist"));
        if(name != null && !name.isEmpty() && !Objects.equals(news.getName(), name)){
            news.setName(name);
        }
        if(description != null && !description.isEmpty() && !Objects.equals(news.getDescription(), description)){
            news.setDescription(description);
        }
        if(dateOfEvent != null && dateOfEvent.isAfter(LocalDate.now()) && !Objects.equals(news.getDateOfEvent(), dateOfEvent)){
            news.setDateOfEvent(dateOfEvent);
        }
        if(place != null && !place.isEmpty() && !Objects.equals(news.getPlace(), place)){
            news.setPlace(place);
        }
        if(startingTime != null && !Objects.equals(news.getStartingTime(), startingTime) && endingTime != null && startingTime.isBefore(endingTime)){
            news.setStartingTime(startingTime);
        }
        if(endingTime != null && !Objects.equals(news.getEndingTime(), endingTime) && startingTime != null && endingTime.isAfter(startingTime)){
            news.setEndingTime(endingTime);
        }
    }
}