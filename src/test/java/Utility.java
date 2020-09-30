import com.github.javafaker.Faker;
import com.google.gson.*;
import com.torus.acquirerservice.dto.AcquirerRequestDto;
import com.torus.merchantservice.dto.MerchantRequestDto;
import com.torus.terminalservice.dto.TerminalDto;
import com.torus.userservice.dto.UserDto;
import org.apache.commons.lang.RandomStringUtils;
import org.jeasy.random.EasyRandom;
import org.jeasy.random.EasyRandomParameters;
import org.jeasy.random.FieldPredicates;
import org.jeasy.random.api.Randomizer;
import org.junit.Test;

import java.lang.reflect.Type;
import java.math.BigInteger;
import java.time.Instant;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

public class Utility {
  public Utility() {
  }

  public static class IntegerRandomizer implements Randomizer<Integer> {
    private final Integer LENGTH;

    public IntegerRandomizer(int length) {
      LENGTH = length;
    }

    @Override
    public Integer getRandomValue() {
      return ThreadLocalRandom.current().nextInt(1, LENGTH);
    }
  }

  public static class StoreIdRandomizer implements Randomizer<String> {
    @Override
    public String getRandomValue() {
      String generatedString = RandomStringUtils.randomAlphanumeric(10);
      return generatedString;
    }
  }

  public static String generateValidCreditCardNumber() {
    Faker faker = new Faker();
    return faker.finance().creditCard();
  }

  static class LocalDateAdapter implements JsonSerializer<LocalDate> {

    public JsonElement serialize(LocalDate date, Type typeOfSrc, JsonSerializationContext context) {
      return new JsonPrimitive(date.format(DateTimeFormatter.ISO_LOCAL_DATE)); // "yyyy-mm-dd"
    }
  }

  public static String generateCreateAcquirers() {
    EasyRandomParameters easyRandomParameters = new EasyRandomParameters()
        .randomize(FieldPredicates.ofType(Integer.class), new IntegerRandomizer(12));
    EasyRandom random = new EasyRandom(easyRandomParameters);
    AcquirerRequestDto acquirerRequestDto = new AcquirerRequestDto();
    acquirerRequestDto = random.nextObject(AcquirerRequestDto.class);
    Gson gson = getGson();
    String json = gson.toJson(acquirerRequestDto);
    return json;
  }

  public static String generateCreateMerchantRequestBody() {
    EasyRandomParameters easyRandomParameters = new EasyRandomParameters()
        .randomize(FieldPredicates.ofType(Integer.class), new IntegerRandomizer(10));
    EasyRandom easyRandom = new EasyRandom();
    MerchantRequestDto merchantRequestDto = new MerchantRequestDto();
    merchantRequestDto = easyRandom.nextObject(MerchantRequestDto.class);
    //merchantRequestDto.setCardBrands(Collections.singletonList("VISA"));
    Gson gson = getGson();
    String json = gson.toJson(merchantRequestDto);
    return json;
  }

  private static Gson getGson() {
    return new GsonBuilder()
        .setPrettyPrinting()
        .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
        .create();
  }

  public static String generateCreateUserRequestBody() {
    EasyRandomParameters easyRandomParameters = new EasyRandomParameters()
        .randomize(FieldPredicates.ofType(Integer.class), new IntegerRandomizer(10));
    EasyRandom easyRandom = new EasyRandom();
    UserDto userDto = new UserDto();
    userDto = easyRandom.nextObject(UserDto.class);
    Gson gson = getGson();
    String json = gson.toJson(userDto);
    return json;
  }

  public static String generateTerminalCreateRequestBody() {
    EasyRandom easyRandom = new EasyRandom();
    TerminalDto terminalDto = new TerminalDto();
    terminalDto = easyRandom.nextObject(TerminalDto.class);
    Faker faker = new Faker();
    String acquirerTerminalID = String.valueOf(faker.number().numberBetween(0, 34));
    terminalDto.setAcquirerTerminalNumber(acquirerTerminalID);
    Gson gson = getGson();
    String json = gson.toJson(terminalDto);
    return json;
  }


  public static String getAlphaNumericString(int n) {
    String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        + "0123456789"
        + "abcdefghijklmnopqrstuvxyz";
    StringBuilder sb = new StringBuilder(n);

    for (int i = 0; i < n; i++) {

      int index
          = (int) (AlphaNumericString.length()
          * Math.random());
      sb.append(AlphaNumericString
          .charAt(index));
    }
    return sb.toString();
  }

  public static String replaceStr(String text) {

    return text.replace("\"", "");
  }

  public static String replaceCreditCardFormat(String text) {

    return text.replace("-", "");
  }

  public static String getRandomNumber(int digCount) {
    Random rnd = new Random();
    StringBuilder sb = new StringBuilder(digCount);
    for (int i = 0; i < digCount; i++)
      sb.append((char) ('0' + rnd.nextInt(10)));
    return sb.toString();
  }

  public static int getRandomMerchantID() {
    IntegerRandomizer aa = new IntegerRandomizer(2020);
    int randomValue = aa.getRandomValue();
    return randomValue;

  }

  public static BigInteger generateNumeric(int n) {

    return new BigInteger(getRandomNumber(n));
  }

  public static Instant iso8601ToInstant(String s) {
    DateTimeFormatter[] dateTimeFormatters = {
        DateTimeFormatter.ISO_INSTANT,
        DateTimeFormatter.ISO_OFFSET_DATE_TIME,
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ssZ")
    };
    for (DateTimeFormatter dtf : dateTimeFormatters) {
      try {
        OffsetDateTime odt = OffsetDateTime.parse(s, dtf);
        Instant i = odt.toInstant();
        return i;
      } catch (DateTimeParseException dtpe) {
        ;
      }
    }
    throw new IllegalArgumentException(String.format("FAILED TO PARSE %s", s));
  }

  public static int findMinDateIndex(String[] dateArray) {
    ArrayList<Long> timeStampArray = new ArrayList<Long>();
    int a = 0;

    for (int i = 0; i < dateArray.length; i++) {
      Instant index = iso8601ToInstant(dateArray[i]);
      long convertedDate = index.toEpochMilli();
      timeStampArray.add(convertedDate);
    }
    long min = timeStampArray.get(0);
    for (int i = 0; i < timeStampArray.size(); i++) {
      if (timeStampArray.get(i) < min) {
        min = timeStampArray.get(i);
        a = i;
      }
    }
    return a;
  }

}
