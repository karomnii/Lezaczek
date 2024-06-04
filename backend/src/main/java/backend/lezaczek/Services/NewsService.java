package backend.lezaczek.Services;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.Model.News;
import backend.lezaczek.Model.User;
import backend.lezaczek.Repositories.NewsRepository;
import backend.lezaczek.Repositories.UsersRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

@Service
public class NewsService {
    private final NewsRepository newsRepository;

    private UsersRepository usersRepository;

    @Autowired
    JwtTokenHelper jwtTokenHelper;
    @Autowired
    public NewsService(NewsRepository newsRepository, UsersRepository usersRepository) {
        this.newsRepository = newsRepository;
        this.usersRepository = usersRepository;
    }

    public List<News> getNews(HttpServletRequest request) {
        try {
            jwtTokenHelper.extractUserId(request);
            return newsRepository.findAll();
        }
        catch (Throwable e){
            throw new RuntimeException("Authorization token is invalid");
        }
    }

    public Optional<News> getNewsById(Long newsId, HttpServletRequest request){
        try {
            jwtTokenHelper.extractUserId(request);
            return newsRepository.findById(newsId);
        }
        catch (Throwable e){
            throw new RuntimeException("Authorization token is invalid");
        }
    }

    public News addNews(News news, HttpServletRequest request){
        Optional<News> newsByName = newsRepository.findNewsByName(news.getName());
        if(newsByName.isPresent()){
            throw new RuntimeException("News already exists");
        }
        boolean isValid = isNewsValid(news);
        if(!isValid){
            throw new RuntimeException("Invalid news parameters");
        }
        //TODO: try to implement userValidation method
        Long userId;
        try {
            userId = jwtTokenHelper.extractUserId(request);
//            userId = 2L; //test value
        }
        catch (Throwable e){
            throw new RuntimeException("Authorization token is invalid");
        }
        User user = usersRepository.findUserByUserId(userId);
        if(user.getIsAdmin() == 0){
            throw new RuntimeException("You don't have permission to this resource");
        }
        news.setUserId(userId);
        news.setDateAdded(LocalDateTime.now());
        newsRepository.save(news);
        return news;
    }

    public void deleteNews(Long newsId, HttpServletRequest request) {
        Optional<News> newsOptional = newsRepository.findById(newsId);
        if(newsOptional.isPresent()){
            Long userId;
            try {
                userId = jwtTokenHelper.extractUserId(request);
//                userId = 2L; //test value
            }
            catch (Throwable e){
                throw new RuntimeException("Authorization token is invalid");
            }
            User user = usersRepository.findUserByUserId(userId);
            if(user.getIsAdmin() == 1){
                newsRepository.deleteById(newsId);
            }
            else{
                throw new RuntimeException("You don't have permission to this resource");
            }
        }
        else{
            throw new RuntimeException("News not found");
        }
    }

    @Transactional
    public News updateNews(HttpServletRequest request, Long newsId, String name, String description, String dateOfEvent, String place, String startingTime, String endingTime) {
        News news = newsRepository.findById(newsId).orElseThrow(() ->new RuntimeException("News doesn't exist"));
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("uuuu-MM-dd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        Long userId;
        try {
            userId = jwtTokenHelper.extractUserId(request);
//            userId = 2L; //test value
        }
        catch (Throwable e){
            throw new RuntimeException("Authorization token is invalid");
        }
        User user = usersRepository.findUserByUserId(userId);
        if(user.getIsAdmin() == 0){
            throw new RuntimeException("You don't have permission to this resource");
        }
        if(name != null){
            if(name.isEmpty()){
                throw new RuntimeException("News name is invalid. Changes discarded");
            }
            Optional <News> newsOptional = newsRepository.findNewsByName(name);
            if(newsOptional.isPresent()){
                throw new RuntimeException("This event name already exists");
            }
            news.setName(name);
        }
        if(description != null){
            if(description.isEmpty()){
                throw new RuntimeException("News description is invalid. Changes discarded");
            }
            news.setDescription(description);
        }
        if (dateOfEvent != null) {
            try {
                LocalDate parsedDateOfEvent = LocalDate.parse(dateOfEvent, dateFormatter);
                if (!parsedDateOfEvent.isAfter(LocalDate.now())) {
                    throw new RuntimeException("News date is invalid. Changes discarded");
                }
                news.setDateOfEvent(parsedDateOfEvent);
            } catch (DateTimeParseException e) {
                throw new RuntimeException("News date format is invalid. Changes discarded");
            }
        }
        if(place != null ){
            if(place.isEmpty()){
                throw new RuntimeException("News place is invalid. Changes discarded");
            }
            news.setPlace(place);
        }
        if(startingTime != null){
            try {
                LocalTime parsedStartingTime = LocalTime.parse(startingTime, timeFormatter);
                if((endingTime != null && !parsedStartingTime.isBefore(LocalTime.parse(endingTime, timeFormatter)))
                        || (endingTime == null && !news.getEndingTime().isAfter(parsedStartingTime))){
                    throw new RuntimeException("News starting time is invalid. Changes discarded");
                }
                news.setStartingTime(parsedStartingTime);
            }
            catch (DateTimeParseException e){
                throw new RuntimeException("News starting time format is invalid. Changes discarded");
            }
        }
        if(endingTime != null ){
            try{
                LocalTime parsedEndingTime = LocalTime.parse(endingTime, timeFormatter);
                if((startingTime != null && !parsedEndingTime.isAfter(LocalTime.parse(startingTime, timeFormatter)))
                        || (startingTime == null && !news.getStartingTime().isBefore(parsedEndingTime))){
                    throw new RuntimeException("News ending time is invalid. Changes discarded");
                }
                news.setEndingTime(parsedEndingTime);
            }
            catch (DateTimeParseException e){
                throw new RuntimeException("News ending time format is invalid. Changes discarded");
            }
        }
        return news;
    }

    boolean isNewsValid(News news){
        return !news.getName().isEmpty() && !news.getDescription().isEmpty() && !news.getPlace().isEmpty()
                && news.getStartingTime().isBefore(news.getEndingTime());
    }

}