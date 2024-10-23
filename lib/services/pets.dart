import 'dart:async';
import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/services/client.dart';
import "package:dio/dio.dart";

class DioClient {
  // final Dio _dio = Dio();

  // final _baseUrl = 'https://coded-pets-api-auth.eapi.joincoded.com';

  Future<List<Pet>> getPets() async {
    List<Pet> pets = [];
    try {
      Response response = await Client.dio.get('/pets');
      pets = (response.data as List).map((pet) => Pet.fromJson(pet)).toList();
    } on DioException catch (error) {
      print(error);
    }
    return pets;
  }

  Future<Pet> createPet({required Pet pet}) async {
    late Pet retrievedPet;
    try {
      FormData data = FormData.fromMap({
        "name": pet.name,
        "age": pet.age,
        "gender": pet.gender,
        "image": pet.image,//await MultipartFile.fromFile(
          //pet.image,
        //),
      });
      Response response = await Client.dio.post('/pets', data: data);
      retrievedPet = Pet.fromJson(response.data);
    } on DioException catch (error) {
      print(error);
    }
    return retrievedPet;
  }

  Future<Pet> updatePet({required Pet pet}) async {
    late Pet retrievedPet;
    try {
      FormData data = FormData.fromMap({
        "name": pet.name,
        "age": pet.age,
        "adopted": pet.adopted,
        "gender": pet.gender,
        "image": await MultipartFile.fromFile(
          pet.image,
        ),
      });

      Response response =
          await Client.dio.put('/pets/${pet.id}', data: data);
      retrievedPet = Pet.fromJson(response.data);
    } on DioException catch (error) {
      print(error);
    }
    return retrievedPet;
  }

  Future<void> deletePet({required int petId}) async {
    try {
      await Client.dio.delete('/pets/$petId');
    } on DioException catch (error) {
      print(error);
    }
  }

  Future<Pet> adoptPet({required int petId}) async {
    late Pet retrievedPet;
    try {
      Response response = await Client.dio.post('/pets/adopt/$petId');
      retrievedPet = Pet.fromJson(response.data);
    } on DioException catch (error) {
      print(error);
    }
    return retrievedPet;
  }
}
