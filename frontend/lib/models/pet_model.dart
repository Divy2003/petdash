class PetModel {
  final String? id;
  final String? owner;
  final String name;
  final String? species;
  final String? typeOfPet;
  final String? breed;
  final String? weight;
  final String? gender;
  final DateTime? birthday;
  final List<String>? allergies;
  final String? currentMedications;
  final DateTime? lastVaccinatedDate;
  final List<Vaccination>? vaccinations;
  final List<String>? favoriteToys;
  final String? profileImage;
  
  // Additional Info
  final bool? neutered;
  final bool? vaccinated;
  final bool? friendlyWithDogs;
  final bool? friendlyWithCats;
  final bool? friendlyWithKidsUnder10;
  final bool? friendlyWithKidsOver10;
  final bool? microchipped;
  final bool? purebred;
  final bool? pottyTrained;
  
  // Primary Services
  final String? preferredVeterinarian;
  final String? preferredPharmacy;
  final String? preferredGroomer;
  final String? favoriteDogPark;

  PetModel({
    this.id,
    this.owner,
    required this.name,
    this.species,
    this.typeOfPet,
    this.breed,
    this.weight,
    this.gender,
    this.birthday,
    this.allergies,
    this.currentMedications,
    this.lastVaccinatedDate,
    this.vaccinations,
    this.favoriteToys,
    this.profileImage,
    this.neutered,
    this.vaccinated,
    this.friendlyWithDogs,
    this.friendlyWithCats,
    this.friendlyWithKidsUnder10,
    this.friendlyWithKidsOver10,
    this.microchipped,
    this.purebred,
    this.pottyTrained,
    this.preferredVeterinarian,
    this.preferredPharmacy,
    this.preferredGroomer,
    this.favoriteDogPark,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'],
      owner: json['owner'],
      name: json['name'] ?? '',
      species: json['species'],
      typeOfPet: json['typeOfPet'],
      breed: json['breed'],
      weight: json['weight'],
      gender: json['gender'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      allergies: json['allergies'] != null ? List<String>.from(json['allergies']) : null,
      currentMedications: json['currentMedications'],
      lastVaccinatedDate: json['lastVaccinatedDate'] != null ? DateTime.parse(json['lastVaccinatedDate']) : null,
      vaccinations: json['vaccinations'] != null 
          ? (json['vaccinations'] as List).map((v) => Vaccination.fromJson(v)).toList() 
          : null,
      favoriteToys: json['favoriteToys'] != null ? List<String>.from(json['favoriteToys']) : null,
      profileImage: json['profileImage'],
      neutered: json['neutered'],
      vaccinated: json['vaccinated'],
      friendlyWithDogs: json['friendlyWithDogs'],
      friendlyWithCats: json['friendlyWithCats'],
      friendlyWithKidsUnder10: json['friendlyWithKidsUnder10'],
      friendlyWithKidsOver10: json['friendlyWithKidsOver10'],
      microchipped: json['microchipped'],
      purebred: json['purebred'],
      pottyTrained: json['pottyTrained'],
      preferredVeterinarian: json['preferredVeterinarian'],
      preferredPharmacy: json['preferredPharmacy'],
      preferredGroomer: json['preferredGroomer'],
      favoriteDogPark: json['favoriteDogPark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (owner != null) 'owner': owner,
      'name': name,
      if (species != null) 'species': species,
      if (typeOfPet != null) 'typeOfPet': typeOfPet,
      if (breed != null) 'breed': breed,
      if (weight != null) 'weight': weight,
      if (gender != null) 'gender': gender,
      if (birthday != null) 'birthday': birthday!.toIso8601String(),
      if (allergies != null) 'allergies': allergies,
      if (currentMedications != null) 'currentMedications': currentMedications,
      if (lastVaccinatedDate != null) 'lastVaccinatedDate': lastVaccinatedDate!.toIso8601String(),
      if (vaccinations != null) 'vaccinations': vaccinations!.map((v) => v.toJson()).toList(),
      if (favoriteToys != null) 'favoriteToys': favoriteToys,
      if (profileImage != null) 'profileImage': profileImage,
      if (neutered != null) 'neutered': neutered,
      if (vaccinated != null) 'vaccinated': vaccinated,
      if (friendlyWithDogs != null) 'friendlyWithDogs': friendlyWithDogs,
      if (friendlyWithCats != null) 'friendlyWithCats': friendlyWithCats,
      if (friendlyWithKidsUnder10 != null) 'friendlyWithKidsUnder10': friendlyWithKidsUnder10,
      if (friendlyWithKidsOver10 != null) 'friendlyWithKidsOver10': friendlyWithKidsOver10,
      if (microchipped != null) 'microchipped': microchipped,
      if (purebred != null) 'purebred': purebred,
      if (pottyTrained != null) 'pottyTrained': pottyTrained,
      if (preferredVeterinarian != null) 'preferredVeterinarian': preferredVeterinarian,
      if (preferredPharmacy != null) 'preferredPharmacy': preferredPharmacy,
      if (preferredGroomer != null) 'preferredGroomer': preferredGroomer,
      if (favoriteDogPark != null) 'favoriteDogPark': favoriteDogPark,
    };
  }

  PetModel copyWith({
    String? id,
    String? owner,
    String? name,
    String? species,
    String? typeOfPet,
    String? breed,
    String? weight,
    String? gender,
    DateTime? birthday,
    List<String>? allergies,
    String? currentMedications,
    DateTime? lastVaccinatedDate,
    List<Vaccination>? vaccinations,
    List<String>? favoriteToys,
    String? profileImage,
    bool? neutered,
    bool? vaccinated,
    bool? friendlyWithDogs,
    bool? friendlyWithCats,
    bool? friendlyWithKidsUnder10,
    bool? friendlyWithKidsOver10,
    bool? microchipped,
    bool? purebred,
    bool? pottyTrained,
    String? preferredVeterinarian,
    String? preferredPharmacy,
    String? preferredGroomer,
    String? favoriteDogPark,
  }) {
    return PetModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      species: species ?? this.species,
      typeOfPet: typeOfPet ?? this.typeOfPet,
      breed: breed ?? this.breed,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      lastVaccinatedDate: lastVaccinatedDate ?? this.lastVaccinatedDate,
      vaccinations: vaccinations ?? this.vaccinations,
      favoriteToys: favoriteToys ?? this.favoriteToys,
      profileImage: profileImage ?? this.profileImage,
      neutered: neutered ?? this.neutered,
      vaccinated: vaccinated ?? this.vaccinated,
      friendlyWithDogs: friendlyWithDogs ?? this.friendlyWithDogs,
      friendlyWithCats: friendlyWithCats ?? this.friendlyWithCats,
      friendlyWithKidsUnder10: friendlyWithKidsUnder10 ?? this.friendlyWithKidsUnder10,
      friendlyWithKidsOver10: friendlyWithKidsOver10 ?? this.friendlyWithKidsOver10,
      microchipped: microchipped ?? this.microchipped,
      purebred: purebred ?? this.purebred,
      pottyTrained: pottyTrained ?? this.pottyTrained,
      preferredVeterinarian: preferredVeterinarian ?? this.preferredVeterinarian,
      preferredPharmacy: preferredPharmacy ?? this.preferredPharmacy,
      preferredGroomer: preferredGroomer ?? this.preferredGroomer,
      favoriteDogPark: favoriteDogPark ?? this.favoriteDogPark,
    );
  }
}

class Vaccination {
  final String name;
  final DateTime date;

  Vaccination({
    required this.name,
    required this.date,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      name: json['name'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
    };
  }
}
