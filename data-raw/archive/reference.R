source(here::here("data-raw", "pins_functions.R"))

######################### Sections
sections <- dplyr::tibble(
  axis = "1",
  name = "Section",
  value = c(0:9, LETTERS[c(2:4, 6:8, 24)]),
  label = c(
    "Medical and Surgical",
    "Obstetrics",
    "Placement",
    "Administration",
    "Measurement and Monitoring",
    "Extracorporeal or Systemic Assistance and Performance",
    "Extracorporeal or Systemic Therapies",
    "Osteopathic",
    "Other Procedures",
    "Chiropractic",
    "Imaging",
    "Nuclear Medicine",
    "Radiation Therapy",
    "Physical Rehabilitation and Diagnostic Audiology",
    "Mental Health",
    "Substance Abuse Treatment",
    "New Technology"
  )
)

pin_update(
  sections,
  name = "sections",
  title = "ICD-10-PCS Sections",
  description = "ICD-10-PCS Sections"
)

######################### Systems
# Medical and Surgical
msg <- data.frame(
  section = "0",
  axis = "2",
  name = "Body System",
  value = c(0:9, LETTERS[c(2:4, 6:8, 10:14, 16:25)]),
  label = c("Central Nervous System and Cranial Nerves",
            "Peripheral Nervous System",
            "Heart and Great Vessels",
            "Upper Arteries",
            "Lower Arteries",
            "Upper Veins",
            "Lower Veins",
            "Lymphatic and Hemic Systems",
            "Eye",
            "Ear, Nose, Sinus",
            "Respiratory System",
            "Mouth and Throat",
            "Gastrointestinal System",
            "Hepatobiliary System and Pancreas",
            "Endocrine System",
            "Skin and Breast",
            "Subcutaneous Tissue and Fascia",
            "Muscles",
            "Tendons",
            "Bursae and Ligaments",
            "Head and Facial Bones",
            "Upper Bones",
            "Lower Bones",
            "Upper Joints",
            "Lower Joints",
            "Urinary System",
            "Female Reproductive System",
            "Male Reproductive System",
            "Anatomical Regions, General",
            "Anatomical Regions, Upper Extremities",
            "Anatomical Regions, Lower Extremities"))

# Obstetrics
obs <- data.frame(
  section = "1",
  axis = "2",
  name = "Body System",
  value = "0",
  label = "Pregnancy")

# Placement
plc <- data.frame(
  section = "2",
  axis = "2",
  name = "Body System",
  value = c("W", "Y"),
  label = c("Anatomical Regions",
            "Anatomical Orifices"))

# Administration
adm <- data.frame(
  section = "3",
  axis = "2",
  name = "Body System",
  value = c("0", "C", "E"),
  label = c("Circulatory",
            "Indwelling Device",
            "Physiological Systems and Anatomical Regions"))

# Measurement and Monitoring
mam <- data.frame(
  section = "4",
  axis = "2",
  name = "Body System",
  value = c("A", "B"),
  label = c("Physiological Systems",
            "Physiological Devices"))

# Extracorporeal or Systemic Assistance and Performance
xpr <- data.frame(
  section = "5",
  axis = "2",
  name = "Body System",
  value = "A",
  label = "Physiological Systems")

# Extracorporeal or Systemic Therapies
xth <- data.frame(
  section = "6",
  axis = "2",
  name = "Body System",
  value = "A",
  label = "Physiological Systems")

# Osteopathic
ost <- data.frame(
  section = "7",
  axis = "2",
  name = "Body System",
  value = "W",
  label = "Anatomical Regions")

# Other Procedures
otp <- data.frame(
  section = "8",
  axis = "2",
  name = "Body System",
  value = c("C", "E"),
  label = c("Indwelling Device",
            "Physiological Systems and Anatomical Regions"))

# Chiropractic
chi <- data.frame(
  section = "9",
  axis = "2",
  name = "Body System",
  value = "W",
  label = "Anatomical Regions")

# Imaging
img <- data.frame(
  section = "B",
  axis = "2",
  name = "Body System",
  value = c(0, 2:5, 7:9,
            LETTERS[c(2, 4, 6:8, 12, 14, 16:18, 20:23, 25)]),
  label = c("Central Nervous System",
            "Heart",
            "Upper Arteries",
            "Lower Arteries",
            "Veins",
            "Lymphatic System",
            "Eye",
            "Ear, Nose, Mouth and Throat",
            "Respiratory System",
            "Gastrointestinal System",
            "Hepatobiliary System and Pancreas",
            "Endocrine System",
            "Skin, Subcutaneous Tissue and Breast",
            "Connective Tissue",
            "Skull and Facial Bones",
            "Non-Axial Upper Bones",
            "Non-Axial Lower Bones",
            "Axial Skeleton, Except Skull and Facial Bones",
            "Urinary System",
            "Female Reproductive System",
            "Male Reproductive System",
            "Anatomical Regions",
            "Fetus and Obstetrical"))

# Nuclear Medicine
nuc <- data.frame(
  section = "C",
  axis = "2",
  name = "Body System",
  value = c(0, 2, 5, 7:9,
            LETTERS[c(2, 4, 6:8, 16, 20, 22:23)]),
  label = c("Central Nervous System",
            "Heart",
            "Veins",
            "Lymphatic and Hematologic System",
            "Eye",
            "Ear, Nose, Mouth and Throat",
            "Respiratory System",
            "Gastrointestinal System",
            "Hepatobiliary System and Pancreas",
            "Endocrine System",
            "Skin, Subcutaneous Tissue and Breast",
            "Musculoskeletal System",
            "Urinary System",
            "Male Reproductive System",
            "Anatomical Regions"))

# Radiation Therapy
rad <- data.frame(
  section = "D",
  axis = "2",
  name = "Body System",
  value = c(0, 7:9,
            LETTERS[c(2, 4, 6:8, 13, 16, 20:23)]),
  label = c("Central and Peripheral Nervous System",
            "Lymphatic and Hematologic System",
            "Eye",
            "Ear, Nose, Mouth and Throat",
            "Respiratory System",
            "Gastrointestinal System",
            "Hepatobiliary System and Pancreas",
            "Endocrine System",
            "Skin",
            "Breast",
            "Musculoskeletal System",
            "Urinary System",
            "Female Reproductive System",
            "Male Reproductive System",
            "Anatomical Regions"))

# Physical Rehabilitation and Diagnostic Audiology
phy <- data.frame(
  section = "F",
  axis = "2",
  name = "Section Qualifier",
  value = c("0", "1"),
  label = c("Rehabilitation", "Diagnostic Audiology"))

# Mental Health
men <- data.frame(
  section = "G",
  axis = "2",
  name = "Body System",
  value = "Z",
  label = "None")

# Substance Abuse Treatment
sub <- data.frame(
  section = "H",
  axis = "2",
  name = "Body System",
  value = "Z",
  label = "None")

# New Technology
new <- data.frame(
  section = "X",
  axis = "2",
  name = "Body System",
  value = c(0, 2, # D, F, H, K, N, R, T, W, X, Y
            LETTERS[c(4, 6, 8, 11, 14, 18, 20, 23:25)]),
  label = c("Nervous System",
            "Cardiovascular System",
            "Gastrointestinal System",
            "Hepatobiliary System and Pancreas",
            "Skin, Subcutaneous Tissue, Fascia and Breast",
            "Muscles, Tendons, Bursae and Ligaments",
            "Bones",
            "Joints",
            "Urinary System",
            "Anatomical Regions",
            "Physiological Systems",
            "Extracorporeal"))

sys <- vctrs::vec_rbind(msg, obs, plc,
                        adm, mam, xpr,
                        xth, ost, otp,
                        chi, img, nuc,
                        rad, phy, men,
                        sub, new) |>
  dplyr::tibble()

pin_update(
  sys,
  name = "systems",
  title = "ICD-10-PCS Systems",
  description = "ICD-10-PCS Systems"
)
