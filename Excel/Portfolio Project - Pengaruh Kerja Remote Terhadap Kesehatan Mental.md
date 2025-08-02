# Pengaruh Kerja Remote terhadap Kesehatan Mental
## Tentang Data
Seiring dengan semakin populernya dunia kerja modern, memahami dampaknya terhadap kesehatan mental, tingkat stres, dan kepuasan kerja menjadi sangat penting. Kumpulan dataset ini dirancang untuk mensimulasikan tren dunia nyata dan menyediakan landasan terstruktur untuk analisis tentang bagaimana lokasi kerja _Remote_, _Hybrid_, dan _Onsite_ berdampak pada karyawan di berbagai industri.

Data ini diambil dari sumber terbuka `Kaggle` : [Link download](https://www.kaggle.com/datasets/waqi786/remote-work-and-mental-health/data)

Link download File hasil analisis : [Portfolio Project - Remote Work.xlsx](https://github.com/user-attachments/files/21557232/Portfolio.Project.-.Remote.Work.xlsx)


## Goal
Meningkatkan kualitas kerja karyawan yang bekerja secara _Remote_ serta mengurangi dampak buruk pengaruh bekerja secara _Remote_ terhadap kesehatan mental. Mengeksplorasi hubungan antara fleksibilitas kerja dan kesejahteraan karyawan dalam lingkungan yang terkendali dan bebas risiko.

## Analisis di bagi menjadi 4 bagian :
Analisis Umum
1. Bagaimana distribusi jenis pekerjaan (Job Role) dan industri (Industry) dalam dataset ini?
2. Berapa rata-rata usia (Age) dan tahun pengalaman kerja (Years of Experience) responden?
3. Bagaimana pembagian responden berdasarkan lokasi kerja (Work Location) (misalnya, _Remote_, _Hybrid_, _Onsite_)?

Analisis Pengaruh Kerja Remote:

4. Apakah ada hubungan antara lokasi kerja (Work Location) dengan tingkat stres (Stress Level) atau kondisi kesehatan mental (Mental Health Condition) yang dilaporkan?
5. Apakah perubahan produktivitas (Productivity Change) bervariasi berdasarkan lokasi kerja (Work Location)?
6. Bagaimana rating keseimbangan kerja-hidup (Work-Life Balance Rating) berbeda antara pekerja _Remote_, _Hybrid_, dan _Onsite_?

Analisis Faktor-faktor Tambahan:

7. Apakah ada korelasi antara jumlah jam kerja per minggu (Hours Worked Per Week) atau jumlah rapat virtual (Number of Virtual Meetings) dengan tingkat stres (Stress Level)?
8. Bagaimana kualitas tidur (Sleep Quality) dan aktivitas fisik (Physical Activity) berhubungan dengan kondisi kesehatan mental (Mental Health Condition) yang dilaporkan?

Analisis Demografis:

9. Apakah ada perbedaan yang signifikan dalam kondisi kesehatan mental (Mental Health Condition) atau tingkat stres (Stress Level) antara kelompok usia (Age) atau gender (Gender) yang berbeda?
10. Apakah ada perbedaan regional (Region) dalam hal tingkat stres (Stress Level) atau kepuasan terhadap kerja remote (Satisfaction with Remote Work)?

### Analisis Umum
1. Bagaimana distribusi jenis pekerjaan (Job Role) dan industri (Industry) dalam dataset ini?

<img width="738" height="161" alt="image" src="https://github.com/user-attachments/assets/c1637e42-3b7e-431e-b8d2-888d28925366" />

Dari total 5000 karyawan dalam datai ini, distribusi industri dan pekerjaan cukup merata dimana karyawan paling banyak bekerja di departemen Financ 747 karyawan. 126 karyawan paling banyak bekerja sebagai Project Manager di bidang Pendidikan dan paling sedikit 72 orang karyawan bekerja sebagai Marketing di bidang yang sama

2. Berapa rata-rata usia (Age) dan tahun pengalaman kerja (Years of Experience) responden?
`=AVERAGE(Impact_of_Remote_Work_Cleaned!B2:B5001)` `=AVERAGE(Impact_of_Remote_Work_Cleaned!F2:F5001)`
Karyawan rata-rata berusia 41 tahun dan pengalaman kerja 18 tahun.

3. Bagaimana pembagian responden berdasarkan lokasi kerja (Work Location) (misalnya, Remote, Hybrid, Onsite)?

<img width="303" height="81" alt="image" src="https://github.com/user-attachments/assets/e088ad96-87ef-4d61-b31b-e4ba0ccfc013" />

Sama halnya dangan jenis pekerjaan dan industri, distribusi lokasi pekerjaan juga cukup merata dimana paling banyak 34% karyawan bekerja remote sedangkan 33% karyawan bekerja secara Hybrid dan Onsite.

### Analisis Pengaruh Kerja Remote:
4. Apakah ada hubungan antara lokasi kerja (Work Location) dengan tingkat stres (Stress Level) atau kondisi kesehatan mental (Mental Health Condition) yang dilaporkan?

<img width="490" height="102" alt="image" src="https://github.com/user-attachments/assets/300647ac-f232-4be6-8893-b80ed61d2db3" />
<img width="353" height="102" alt="image" src="https://github.com/user-attachments/assets/b9d7b1b9-e357-4045-8cbd-ebe25b64a3ab" />
<img width="422" height="102" alt="image" src="https://github.com/user-attachments/assets/5d159411-df11-41b1-ac04-1ff081908580" />

Koefisien korelasi antara lokasi kerja Hybrid dengan tingkat stres Low -0,8, ini menunjukan adanya hubungan korelasi negatif antara kerja Hybrid dengan tingkat stres Low. Artinya semakin banyak orang yang kerja Hybrid semakin sedikit juga orang mengalami tingkat stres Low. Koefisien korelasi lokasi kerja Onsite dengan tingkat stres Low adalah 0,9. Artinya semakin banyak orang yang bekerja Onsite, semakin banyak juga orang mengalami tingkat stres Low. Hubungan lokasi kerja Remote dengan tingkat stres Low sangat kuat dengan koefisien korelasi mendekati 1, -0,99 yang berarti semakin banyak orang bekerja Remote semakin sedikit juga orang dengan tingkat stres Low.

<img width="569" height="122" alt="image" src="https://github.com/user-attachments/assets/a52ce3f3-ee32-4e39-b561-2925230e37f4" />
<img width="410" height="122" alt="image" src="https://github.com/user-attachments/assets/fc782f1d-c90a-4324-a1db-83cc7887e9e7" />
<img width="470" height="122" alt="image" src="https://github.com/user-attachments/assets/cd0e4eea-49f7-44c6-a86a-2dc5cf2b2f22" />

Ada hubungan korelasi yang cukup kuat antara lokasi kerja Hybrid dengan kondisi kesehatan mental. Setelah menganalisa data saya menemukan hasil seperti berikut. Hybird - Anxiety (0,8), Hyrid - Burnout (-0,8), Hybrid - Depression (0,8), Hybrid - None (0,8). Ada korelasi positif antara kerja Hybrid dengan Anxiety, Depression atau None, yang artinya semakin banyak orang kerja Hybrid semakin banyak juga orang yang mengalami Anxiety, Depression, atau tidak sama sekali. Sedangkan kerja Hybrid dengan Burnout menunjukan korelasi negatif, yang artinya semakin banyak orang yang kerja Hybrid semakin sedikit juga orang yang mengalami kondisi Burnout.
Kerja Onsite juga memlikiki hubungan cukup kuat dengan ke empat jenis kondisi kesehatan mental. Semakin banyak orang kerja Onsite semakin sedikit juga orang mengalami Anxiety, Depression atau tidak sama sekali. Tetapi, semakin banyak orang kerja Onsite semakin banyak juga orang mengalami Burnout. Untuk orang kerja Remote, semakin banyak orang kerja Remote semakin sedikit juga orang mengalami Anxiety atau tidak ada sama sekali.

5. Apakah perubahan produktivitas (Productivity Change) bervariasi berdasarkan lokasi kerja (Work Location)?

<img width="400" height="270" alt="image" src="https://github.com/user-attachments/assets/9bdda833-2108-40b9-b3b8-371525d49d3c" /> <img width="400" height="270" alt="image" src="https://github.com/user-attachments/assets/7435cc40-9d7f-42e2-a876-131038517cd2" /> <img width="400" height="270" alt="image" src="https://github.com/user-attachments/assets/91f99c93-99e2-491d-a11c-5139103e36e0" />

Perubahan produktivitas terhadap lokasi kerja tidak begitu bervariasi. Berdasarkan lokasi kerja, 36% orang yang kerja Hybrid mengalami penurunan produktivitas terbanyak, 31% orang produktivitasnya meningkat dan 33% orang tidak ada perubahan. Ada sedikit perbedaan perubahan produktivitas pada orang yang kerja Onsite, 35% orang tidak ada perubahan, 34% produktivitasnya menurun dan 31% orang produktivitasnya meningkat. Sedangkan kerja Remote 34% orang mengalami penurunan produktivitas dan sekitar 33% orang produktivitasnya meningkat atau tidak ada perubahan.

6. Bagaimana rating keseimbangan kerja-hidup (Work-Life Balance Rating) berbeda antara pekerja remote, hybrid, dan onsite?

<img width="400" height="270" alt="image" src="https://github.com/user-attachments/assets/60f7d09e-0a19-4a20-a972-7670bf00deb8" /> <img width="400" height="270" alt="image" src="https://github.com/user-attachments/assets/165dc8b7-3e7f-466e-a570-44c53c40f977" /> <img width="400" height="270" alt="image" src="https://github.com/user-attachments/assets/c23b98b3-b1a4-40e3-be18-80db79842d73" />

Dalam data ini, rata-rata orang memiliki rating 3 (cukup) pada Work-Life Balance. 348 dari 1649 orang kerja Hybrid paling banyak bekerja dengan Work-Life Balance rating 3. Ini cukup berbeda dibandingkan dengan rating lainnya. Work-Life Balance Rating memiliki sedikit perbedaan pada orang yang kerja Onsite, 366 dari 1637 orang memiliki rating paling banyak di angka 3. Sedangkan kerja Remote 368 dari 1714 orang paling banyak memiliki Work-Life Balance Rating 1. Singkatnya, banyak orang kerja Remote cenderung memiliki Work-Life Balance yang sangat kurang (1) dibandingkan dengan lokasi kerja lainnya. Jumlah orang yang kerja Onsite cukup merata dalam hal rating Work-Life Balance tetapi jumlah orang yang Work-Life Balance cukup (3) paling banyak dimiliki dibandingkan lokasi kerja lainnya. Orang kerja Hybrid paling banyak memiliki Work-Life Balance yang cukup seperti kerja Onsite. Secara keseluruhan, orang yang paling banyak memiliki Work-Life Balance sangat baik (5) adalah yang bekerja Remote, tetapi jumlah orang yang Work-Life Balance sangat kurang(1) juga paling banyak dimiliki orang kerja Remote.

### Analisis Faktor-faktor Tambahan:
7. Apakah ada korelasi antara jumlah jam kerja per minggu (Hours Worked Per Week) atau jumlah rapat virtual (Number of Virtual Meetings) dengan tingkat stres (Stress Level)?

<img width="420" height="103" alt="image" src="https://github.com/user-attachments/assets/6729a8a2-11d9-4a62-a942-badd6a045d19" /> <img width="420" height="103" alt="image" src="https://github.com/user-attachments/assets/50ff225a-0f19-4137-92b8-bcfd24a7969a" />

Koefisien korelasi antara Hours Worked Per Week dengan Stress Level mendakati 0, ini menunjukan hampir tidak ada hubungannya begitu juga Number of Virtual Meetings dengan Stress Level.

8. Bagaimana kualitas tidur (Sleep Quality) dan aktivitas fisik (Physical Activity) berhubungan dengan kondisi kesehatan mental (Mental Health Condition) yang dilaporkan?

### Anxiety

<img width="700" height="502" alt="image" src="https://github.com/user-attachments/assets/b6ad6cf8-c4e2-4b78-b2b4-f7a38f0e2ca9" />

### Burnout

<img width="700" height="502" alt="image" src="https://github.com/user-attachments/assets/b7865c47-aa6a-4bf6-93cb-4ac3a462a515" />

### Depression

<img width="700" height="502" alt="image" src="https://github.com/user-attachments/assets/85694462-9a3f-4027-b9e6-1da8a7c9c9d7" />

### None

<img width="700" height="502" alt="image" src="https://github.com/user-attachments/assets/3e656497-7483-4d68-b95a-3b52e5edf205" />

Kualitas tidur pada orang yang memiliki Anxiety cenderung rata-rata dan mereka sering melakukan aktivitas fisik setiap minggunya. Orang yang mengalami Burnout selama kerja sangat buruk dalam hal Sleep Quality dan mereka juga kerap melakukan aktivitas fisik setiap minggu. Begitu juga dengan orang yang mengalami depresi, banyak diantara mereka kualitas tidurnya buruk dan diantara mereka sering melakukan aktivitas fisik setiap minggu, dan banyak juga yang tidak melakukan aktivitas fisik sama sekali. Di sisi yang lain, banyak orang yang tidak memiliki kondisi kesehatan mental kualitas tidurnya cenferung bagus. Di antara mereka banyak yang tidak melakukan aktivitas fisik dan banyak juga yang melakukan aktivitas fisik setiap minggunya.


### Analisis Demografis:
9. Apakah ada perbedaan yang signifikan dalam kondisi kesehatan mental (Mental Health Condition) atau tingkat stres (Stress Level) antara kelompok usia (Age) atau gender (Gender) yang berbeda?

<img width="700" height="439" alt="image" src="https://github.com/user-attachments/assets/88a59927-74c4-4a01-801b-cc7949a002a4" />

<img width="700" height="439" alt="image" src="https://github.com/user-attachments/assets/b65ed404-9ad7-4406-955c-8c187f784d60" />

Perbedaan antara Mental Health dengan usia dan gender sangat sedikit, begitu juga Stress Level dengan usia. Tetapi terdapat perbedaan yang cukup signifikan antara Stress Level dengan gender. Kelompok gender Prefer not to say paling banyak mengalami Stress Level yang tinggi (440 orang), diikuti oleh Female sebanyak 437 orang. Sedangkan kelompok Gender Male yang paling banyak memiliki Stress Level rendah dan medium (430 dan 442 orang).

10. Apakah ada perbedaan regional (Region) dalam hal tingkat stres (Stress Level) atau kepuasan terhadap kerja remote (Satisfaction with Remote Work)?

<img width="450" height="452" alt="image" src="https://github.com/user-attachments/assets/f1df3a2b-6235-4edd-8f8b-8b5b76f25f18" /> <img width="450" height="452" alt="image" src="https://github.com/user-attachments/assets/af575a93-0227-4a13-9995-826f7ea8623c" /> <img width="450" height="452" alt="image" src="https://github.com/user-attachments/assets/3d870e55-db08-4f52-8f3c-b9d8deb2d9a6" />

Terdapat sedikit perbedaan antara Region dengan Stress Level dan Remote Work. Diantara 6 wilayah Africa, Asia, Europe, North America, Oceania, dan South America hanya sedikit perbedaan jumlah orang yang mengalami Stress Level tinggi, tetapi cukup terlihat pada Stress Level yang rendah dan medium. Oceania memiliki jumlah orang terbanyak (291) dengan tingkat Stress level rendah dibandingkan dengan Europe, North America, dan South America. Pada Stress Level Medium, jumlah orang di Asia paling banyak (296) diikuti oleh Oceania (294), cukup jauh diabndingkan dengan North America.

<img width="450" height="452" alt="image" src="https://github.com/user-attachments/assets/e5223051-dbc4-41b0-a260-184b1968e433" /> <img width="450" height="452" alt="image" src="https://github.com/user-attachments/assets/3e9e9429-8fcd-452b-8fd1-25248ef64014" /> <img width="450" height="452" alt="image" src="https://github.com/user-attachments/assets/e491deb8-8d0c-4d45-864f-edf0f8144371" />

Jumlah orang yang puas dengan kerja Remote berdasarkan semua wilayah cukup merata, tetapi jumlah orang yang tidak puas paling banyak berada di Africa dan South America. South America juga memiliki jumlah orang terbanyak dengan tingkat kepuasan Netral kerja Remote (297 orang), cukup jauh jika dibandingkan dengan South America (261 orang).


## Ringkasan Temuan Analisis Data
Berdasarkan analisis data dari 5.000 karyawan, distribusi pekerjaan dan industri cukup merata, dengan rata-rata karyawan berusia 41 tahun dan memiliki 18 tahun pengalaman kerja. 
Lokasi kerja juga terdistribusi secara merata, dengan persentase karyawan remote, hybrid, dan onsite yang hampir sama.
Hubungan antara lokasi kerja dan tingkat stres menunjukkan pola yang menarik. Bekerja secara remote memiliki korelasi negatif yang sangat kuat dengan tingkat stres rendah, 
yang berarti semakin banyak orang yang bekerja remote, semakin sedikit yang mengalami stres rendah. Sebaliknya, kerja onsite menunjukkan korelasi positif yang kuat dengan 
tingkat stres rendah, yang artinya semakin banyak yang bekerja onsite, semakin banyak pula yang mengalami stres rendah.

Untuk kondisi kesehatan mental, kerja hybrid memiliki korelasi positif yang kuat dengan anxiety, depression, dan kondisi 'none', tetapi memiliki korelasi negatif dengan 
burnout. Kerja onsite menunjukkan pola yang berlawanan, dengan korelasi negatif terhadap anxiety dan depression, namun korelasi positif terhadap burnout. 
Sementara itu, kerja remote memiliki korelasi negatif dengan anxiety dan kondisi 'none'.

Terkait produktivitas, perubahannya tidak terlalu signifikan antar lokasi kerja. Namun, kerja hybrid memiliki penurunan produktivitas terbanyak, diikuti oleh onsite dan 
remote.Dalam hal Work-Life Balance, rata-rata karyawan memberikan rating 3 (cukup). Namun, kerja remote menunjukkan polarisasi yang ekstrem, di mana mereka memiliki jumlah 
karyawan paling banyak dengan rating Work-Life Balance sangat kurang (1) dan sangat baik (5). Sebaliknya, kerja onsite dan hybrid cenderung memiliki distribusi Work-Life Balance 
yang lebih merata, dengan rating 3 menjadi yang paling dominan.

Analisis juga menunjukkan bahwa tidak ada korelasi signifikan antara jam kerja per minggu atau jumlah rapat virtual dengan tingkat stres. Kualitas tidur buruk 
menjadi karakteristik umum bagi mereka yang mengalami burnout dan depresi, meskipun mereka sering melakukan aktivitas fisik.

Mengenai demografi, gender "Prefer not to say" dan Female paling banyak mengalami stres tinggi, sementara Male cenderung memiliki stres rendah dan sedang. Secara geografis, 
Oceania memiliki tingkat stres rendah terbanyak, sedangkan Asia memiliki tingkat stres medium terbanyak. Meskipun kepuasan terhadap kerja remote cukup merata di semua wilayah, 
ketidakpuasan paling banyak ditemukan di Afrika dan Amerika Selatan.


## Rekomendasi untuk Mengurangi Dampak Buruk Kerja Remote terhadap Kesehatan Mental
Menyediakan Dukungan Kesehatan Mental yang Jelas dan Aksesibel: Karena kerja remote memiliki korelasi negatif yang kuat dengan kondisi "none" (tanpa masalah kesehatan mental),
perusahaan perlu proaktif. Sediakan layanan konseling, sesi mindfulness, atau sumber daya online yang mudah diakses untuk membantu karyawan mengelola stres, anxiety, dan depresi.

Mendorong Batasan Antara Jam Kerja dan Waktu Pribadi: Polarisasi Work-Life Balance pada karyawan remote menunjukkan bahwa banyak yang kesulitan membedakan keduanya.
Dorong budaya yang tidak mengharapkan karyawan untuk selalu "tersedia" di luar jam kerja. Berikan pedoman yang jelas tentang kapan harus menanggapi email atau pesan dan kapan saatnya untuk beristirahat.

Melakukan Survei dan Umpan Balik Secara Berkala: Temuan analisis ini adalah gambaran umum. Untuk penyesuaian yang lebih spesifik, lakukan survei internal secara rutin untuk
memahami tantangan unik yang dihadapi oleh karyawan remote di perusahaan Anda. Tanyakan tentang Work-Life Balance, tingkat stres, dan apa yang mereka butuhkan dari manajemen untuk merasa lebih didukung.


> [!NOTE]
> Ini adalah data fiktif yang ditujukan untuk keperluan portofolio. Hasil proyek analisis ini tidak mencerminkan apa yang terjadi di dunia nyata!! Terima kasih.
