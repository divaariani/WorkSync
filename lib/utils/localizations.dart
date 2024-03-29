import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'languageEn': 'English',
      'languageId': 'Indonesian',
      'languageKr': 'Korean',
      'choose': 'Choose Language :',
      'hello': 'Hello',
      'helloDesc': 'Welcome to the app to monitor your work activity',
      'login': 'Log In',
      'loginSuccess' : 'Login Successful !',
      'loginSuccessMessage': 'Welcome to the SISAP',
      'loginFailed' : 'Login Failed !',
      'loginFailedMessage': 'Try again with your correct account',
      'logout': 'Log Out',
      'register': 'Register',
      'registerDesc': 'Register to get started !',
      'welcome': 'Welcome',
      'enterUsername' : 'Username...',
      'enterEmail' : 'Email...',
      'enterPassword' : 'Password...',
      'enterConfirmPassword' : 'Confirm password...',
      'forgotPassword': 'Forgot Password?',
      'anotherLogin' : 'or Login with',
      'anotherRegister' : 'or Register with',
      'dontHaveAccount' : "Don't have an account?",
      'alreadyHaveAccount' : "Already have an account?",
      'checkIn' : "Check In",
      'checkOut' : "Check Out",
      'attendance' : "ATTENDANCE",
      'attendanceTitle' : "Attendance",
      'attendanceFor' : "Attendance For",
      'attendanceType' : "Attendance Type",
      'attendanceList' : "Attendance List",
      'scanAttendance' : "SCAN FOR ATTENDANCE",
      'attendancePosted' : "Attendance Posted",
      'attendancePostedDesc' : "Successfully posted the attendance",
      'attendanceFailed' : "Attendance Failed",
      'attendanceFailedDesc' : "Failed to post the attendance",
      'registered' : "Registered",
      'registerFaceSuccess' : "Successfully register your face recognition",
      'notRegistered': "Not Registered",
      'notRegistered3More' : "You should register your face 3 times!",
      'registerAgain': "Register Again",
      'register2More': "Register your face 2 more times!",
      'register1More': "Register your face 1 more time!",
      'makeSureLocation' : "1. Ensure that you are close to the Attendance Area / Finished Products Warehouse Area",
      'makeSureCamera' : "2. Make sure you are in a well-lit environment for effective face detection",
      'youAre' : "You Are",
      'recognized' : "Recognized",
      'notRecognized' : "Not Recognized",
      'faceRecognition' : "Face Recognition",
      'noFaceFound' : "No user face found.",
      'detect' : "Detect",
      'pleaseWait' : "Please Wait",
      'location' : "Location",
      'outsideArea' : "Outside the allowed area",
      'inTime' : "In Time",
      'in' : "In",
      'out' : "Out",
      'outTime' : "Out Time",
      'features' : "FEATURES",
      'overtime' : "Overtime",
      'overtimeList' : "Overtime List",
      'editOvertime' : "Edit Overtime",
      'addOvertime' : "Add Overtime",
      'overtimePosted' : "Overtime Posted",
      'overtimePostedDesc' : "Your overtime request posted successfully",
      'overtimeEdited' : "Overtime Edited",
      'overtimeEditedDesc' : "Your overtime request edited successfully",
      'rejectOvertime': "Successfully rejected the overtime request",
      'rejectMakeSure': "Are you sure you want to Reject?",
      'approveOvertime': "Successfully approved the overtime request",
      'profile' : "PROFILE",
      'editProfile' : "Edit Profile",
      'performance' : "Performance",
      'department' : "Department",
      'switchTheme' : "Switch Theme",
      'current' : "Current",
      'language' : "Language",
      'seeAll' : "See All",
      'search' : "Search",
      'yes' : "Yes",
      'cancel' : "Cancel",
      'attention' : "Attention !",
      'name' : "Name",
      'from' : "From",
      'until' : "Until",
      'remark' : "Remark",
      'start' : "Start",
      'startTime' : "Select start date",
      'end' : "End",
      'endTime' : "Select end date",
      'submit' : "Submit",
      'save' : "Save",
      'requestFor' : "Request For",
      'requested' : "Requested",
      'reject' : "Reject",
      'rejected' : "Rejected",
      'approve' : "Approve",
      'approved' : "Approved Request",
      'approvals' : "Approvals",
      'attendanceFeature' : "Attendance Feature",
      'overtimeFeature' : "Overtime Feature",
      'leaveFeature' : "Leave Feature",
      'approvalFeature' : "Approval Feature",
      'checkpointTourFeature' : "Checkpoint Tour Feature",
      'monitoringFeature' : "Monitoring Feature",
      'ticketingFeature' : "Ticketing Feature",
      'stockOpnameFeature' : "Stock Opname Feature",
      'featureWarning' : "You do not have access to this feature",
      'leaveList' : "Leave List",
      'leaveType' : "Leave Type",
      'addLeave' : "Add Leave",
      'attachment' : "Attachment",
      'addFile' : "Add File",
      'time' : "Time Start-End",
      'viewPhoto' : "View Photo",
      'priority' : "Priority",
      'category' : "Category",
      'subCategory' : "Sub Category",
      'status' : "Status",
      'addTicketing' : "Add Ticketing",
      'ticketingList' : "Ticketing List",
      'ticketingDetail' : "Ticketing Detail",
      'ticketingTo' : "Ticketing To",
      'ticketingPosted' : "Ticketing Posted",
      'ticketingPostedDesc' : "Your ticketing posted successfully",
      'ticketingFailed' : "Ticketing Failed",
      'ticketingFailedDesc' : "Failed to post the attendance",
      'tryAgain' : "Try Again",
      'attachmentCantEmpty' : "Attachment Can Not Be Empty",
      'assignedTo' : "Assigned To",
      'subject' : "Subject",
      'warehouse' : "Warehouse",
      'warehouseFeature' : "Warehouse Feature",
      'leave' : "Leave",
      'checkpoinTour' : "Checkpoint Tour",
      'monitoring' : "Monitoring",
      'stockopname' : "Stock Opname",
      'patrolling' : "Patrolling",
      'done' : "Done",
      'chooseSite' : "Choose Site",
      'january' : "January",
      'february' : "february",
      'march' : "March",
      'april' : "April",
      'may' : "May",
      'june' : "June",
      'jul' : "July",
      'august' : "August",
      'sept' : "September",
      'okt' : "October",
      'nov' : "November",
      'des' : "December",
      'exportexcel' : "Export Excel",
      'inputyear' : "Input Year",
      'total' : "Total",
      'productnumber': "Product Number",
      'state' : "State",
      'nodata' : "No Data Products",
      'postdraft' : "Post Draft",
      'surestock' : "Are you sure you want to Confirm stock?",
      'uploaded' : "Uploaded",
      'succesupload' : "Successfully stock uploaded",
      'confirm' : "Confirm",
      'posted' : "Posted",
      'draft' : "Draft",
      'scanpatroll' : "Scan QR Room Code you want to patrol",
      'scan' : "Scan",
      'scanFailed' : "Scan Failed",
      'doNotScan' : "Do not scan random barcode",
      'chooselocation' :"Choose Location",
      'scanlocation' : "Scan QR Location Code",
      'finish' : "Finish",
      'barcodescanned': "Barcode Scanned",
      'stocklist' : "Stock List",
      'stockform' : "Stock Form",
      'auditby' : "Audit By",
      'lotnumber' : "Lot Number",
      'namabarang' : "Item Name",
      'merk' : "Merk",
      'stock' : "Stock",
      'unit' : "Unit",
      'upload' : "Upload",
      'add' : "Add",
      'entermanually' : "Enter Manually",
      'scanbarcode' : "Scan Barcode",
      'suredelete' : "Are you sure you want to delete",
      'sureLogOut' : "Are you sure you want to Log Out?",
      'refreshData' : "Refresh Data",
      'noDataa' : "No Data",
      'doPicking' : "DO Picking",
      'truck' : "Truck",
      'pack' : "Pack",
      'chooseTruck' : "Choose Truck",
      'scanTruck' : "Scan Truck",
      'truckForm' : "Truck Form",
      'managedBy' : "Managed by",
      'next' : "Next",
      'productForm' : "Product Form",
      'productList' : "Product List",
      'addProduct' : "Add Product",
      'succesproductupload' : "Successfully product uploaded",
      'result' : "Result",
      'ticketing' : "Ticketing",
    },
    'id': {
      'languageEn': 'Inggris',
      'languageId': 'Indonesia',
      'languageKr': 'Korea',
      'choose': 'Pilih Bahasa :',
      'hello': 'Hai',
      'helloDesc': 'Selamat datang di aplikasi monitoring aktivitas kerja Anda',
      'login': 'Masuk',
      'loginSuccess' : 'Berhasil Masuk !',
      'loginSuccessMessage': 'Selamat datang di aplikasi SISAP',
      'loginFailed' : 'Gagal Masuk !',
      'loginFailedMessage': 'Coba lagi dengan akun yang benar',
      'logout': 'Keluar',
      'register': 'Daftar',
      'registerDesc': 'Daftar untuk memulai !',
      'welcome': 'Selamat Datang',
      'enterUsername' : 'Nama Pengguna...',
      'enterEmail' : 'Email...',
      'enterPassword' : 'Kata sandi...',
      'enterConfirmPassword' : 'Konfirmasi kata sandi...',
      'forgotPassword': 'Lupa kata sandi?',
      'anotherLogin' : 'atau Masuk dengan',
      'anotherRegister' : 'atau Daftar dengan',
      'dontHaveAccount' : "Belum memiliki akun?",
      'alreadyHaveAccount' : "Sudah memiliki akun?",
      'checkIn' : "Masuk",
      'checkOut' : "Pulang",
      'attendance' : "KEHADIRAN",
      'attendanceTitle' : "Kehadiran",
      'attendanceFor' : "Kehadiran untuk",
      'attendanceType' : "Tipe Kehadiran",
      'attendanceList' : "Daftar Kehadiran",
      'scanAttendance' : "DETEKSI UNTUK PRESENSI",
      'attendancePosted' : "Berhasil Presensi",
      'attendancePostedDesc' : "Berhasil melakukan presensi, selamat",
      'attendanceFailed' : "Gagal Presensi",
      'attendanceFailedDesc' : "Gagal melakukan presensi, coba lagi",
      'registered' : "Terdaftar",
      'registerFaceSuccess' : "Berhasil mendaftar deteksi wajah Anda",
      'notRegistered': "Tidak Terdaftar",
      'notRegistered3More' : "Anda harus mendaftar wajah 3 kali!",
      'registerAgain': "Daftar Lagi",
      'register2More': "Daftar wajah Anda 2 kali lagi!",
      'register1More': "Daftar wajah Anda 1 kali lagi!",
      'makeSureLocation' : "1. Pastikan Anda berada di dekat area absensi / area gudang hasil akhir",
      'makeSureCamera' : "2. Pastikan Anda berada di tempat yang terang untuk efektifitas deteksi wajah",
      'youAre' : "Anda",
      'recognized' : "Terdeteksi",
      'notRecognized' : "Tidak Terdeteksi",
      'faceRecognition' : "Deteksi Wajah",
      'noFaceFound' : "Wajah pengguna tidak ditemukan",
      'detect' : "Deteksi",
      'pleaseWait' : "Mohon tunggu",
      'location' : "Lokasi",
      'outsideArea' : "Di luar area yang ditentukan",
      'inTime' : "Waktu Masuk",
      'in' : "Masuk",
      'out' : "Pulang",
      'outTime' : "Waktu Pulang",
      'features' : "FITUR - FITUR",
      'overtime' : "Lembur",
      'overtimeList' : "Daftar Lembur",
      'editOvertime' : "Ubah Lembur",
      'addOvertime' : "Tambah Lembur",
      'overtimePosted' : "Lembur Terkirim",
      'overtimePostedDesc' : "Permohonan lembur Anda berhasil terkirim",
      'overtimeEdited' : "Lembur Teredit",
      'overtimeEditedDesc' : "Permohonan lembur Anda berhasil diedit",
      'rejectOvertime': "Berhasil menolak permohonan lembur",
      'rejectMakeSure': "Apakah Anda yakin akan menolak?",
      'approveOvertime': "Berhasil mengakui permohonan lembur",
      'profile' : "PROFIL",
      'editProfile' : "Ubah Profil",
      'department' : "Departemen",
      'performance' : "Performa",
      'switchTheme' : "Ganti Tema",
      'current' : "Saat Ini",
      'language' : "Bahasa",
      'seeAll' : "Lihat Semua",
      'search' : "Cari",
      'yes' : "Ya",
      'cancel' : "Batal",
      'attention' : "Perhatian !",
      'name' : "Nama",
      'from' : "Dari",
      'until' : "Sampai",
      'remark' : "Keterangan",
      'start' : "Mulai",
      'startTime' : "Tanggal mulai",
      'end' : "Selesai",
      'endTime' : "Tanggal selesai",
      'submit' : "Kirim",
      'save' : "Simpan",
      'requestFor' : "Permohonan untuk",
      'requested' : "Diajukan",
      'reject' : "Tolak",
      'rejected' : "Ditolak",
      'approve' : "Akui",
      'approved' : "Permohonan Diakui",
      'approvals' : "Persetujuan",
      'attendanceFeature' : "Fitur Kehadiran",
      'overtimeFeature' : "Fitur Lembur",
      'leaveFeature' : "Fitur Izin",
      'approvalFeature' : "Fitur Persetujuan",
      'checkpointTourFeature' : "Fitur Pemeriksaan",
      'monitoringFeature' : "Fitur Pemantauan",
      'ticketingFeature' : "Fitur Laporan",
      'stockOpnameFeature' : "Fitur Pengelolaan Stok",
      'featureWarning' : "Anda tidak memiliki akses untuk fitur ini",
      'leaveList' : "Daftar Izin",
      'leaveType' : "Tipe Izin",
      'addLeave' : "Tambah Izin",
      'attachment' : "Lampiran",
      'addFile' : "Tambah Berkas",
      'time' : "Waktu Mulai-Selesai",
      'viewPhoto' : "Lihat Foto",
      'priority' : "Prioritas",
      'category' : "Kategori",
      'subCategory' : "Sub Kategori",
      'status' : "Keadaan",
      'addTicketing' : "Tambah Laporan",
      'ticketingList' : "Daftar Laporan",
      'ticketingDetail' : "Detail Laporan",
      'ticketingTo' : "Laporan Kepada",
      'ticketingPosted' : "Laporan Terkirim",
      'ticketingPostedDesc' : "Laporan Anda berhasil dikirim",
      'ticketingFailed' : "Laporan Gagal",
      'ticketingFailedDesc' : "Laporan Anda gagal dikirim",
      'tryAgain' : "Coba Lagi",
      'attachmentCantEmpty' : "Lampiran tidak boleh kosong!",
      'assignedTo' : "Ditugaskan Kepada",
      'subject' : "Subyek",
      'warehouse' : "Gudang",
      'warehouseFeature' : "Fitur Gudang",
      'leave' : "Izin",
      'checkpoinTour' : "Pemeriksaan",
      'monitoring' : "Pemantauan",
      'stockopname' : "Pengelolaan Stok",
      'patrolling' : "Berpatroli",
      'done' : "Selesai",
      'chooseSite' : "Pilih Lokasi",
      'january' : "Januari",
      'february' : "Februari",
      'march' : "Maret",
      'april' : "April",
      'may' : "Mei",
      'june' : "Juni",
      'jul' : "Juli",
      'august' : "Agustus",
      'sept' : "September",
      'okt' : "Oktober",
      'nov' : "November",
      'des' : "Desember",
      'exportexcel' : "Eksport Excel",
      'inputyear' : "Masukkan Tahun",
      'total' : "Jumlah",
      'productnumber': "Nomor Produk",
      'state' : "Status",
      'nodata' : "Tidak Ada Data Produk",
      'postdraft' : "Posting Draf",
      "surestock" : "Apakah anda yakin ingin konfirmasi stok?",
      'uploaded' : "Diunggah",
      'succesupload' : "Berhasil unggah stok",
      'confirm' : "Konfirmasi",
      'posted' : "Diposting",
      'draft' : "Draf",
      'scanpatroll' : "Pindai Kode QR Ruangan yang ingin dipatroli",
      'scan' : "Pindai",
      'scanFailed' : "Gagal dipindai",
      'doNotScan' : "Jangan pindai kode secara acak",
      'chooselocation' :"Pilih Lokasi",
      'scanlocation' : "Pindai Kode Lokasi",
      'finish' : "Selesai",
      'barcodescanned': "Kode Dipindai",
      'stocklist' : "Daftar Stok",
      'stockform' : "Formulir Stok",
      'auditby' : "Audit Oleh",
      'lotnumber' : "Nomor Lot",
      'namabarang' : "Nama Barang",
      'merk' : "Merek",
      'stock' : "Stok",
      'unit' : "Satuan",
      'upload' : "Unggah",
      'add' : "Tambah",
      'entermanually' : "Masukkan secara manual",
      'scanbarcode' : "Pindai Kode",
      'suredelete' : "Apakah Anda yakin ingin menghapus",
      'sureLogOut' : "Apakah Anda yakin ingin keluar akun?",
      'refreshData' : "Perbarui Data",
      'noDataa' : "Tidak Ada Data",
      'doPicking' : "Gudang Pickup",
      'truck' : "Truk",
      'pack' : "Pak",
      'chooseTruck' : "Pilih Truck",
      'scanTruck' : "Pindai Truk",
      'truckForm' : "Formulir Truk",
      'managedBy' : "Dikelola oleh",
      'next' : "Selanjutnya",
      'productForm' : "Formulir Produk",
      'productList' : "Daftar Produk",
      'addProduct' : "Tambah Produk",
      'succesproductupload' : "Produk berhasil diupload",
      'result' : "Hasil",
      'ticketing' : "Laporan",
    },
    'ko': {
      'languageEn': '영어 (Eng)',
      'languageId': '인도네시아 (Ina)',
      'languageKr': '한국',
      'choose': '언어 선택 :',
      'hello': '안녕하세요',
      'helloDesc': '일하다 활동 모니터링하는 앱에 오신 것을 환영합니다',
      'login': '로그 인',
      'loginSuccess' : '로그인 성공 !',
      'loginSuccessMessage': 'SISAP앱에 환영합니다',
      'loginFailed' : '로그인 실패 !',
      'loginFailedMessage': '다른 계정으로 다시 시도하세요',
      'logout': '로그 아웃',
      'register': '회원가입',
      'registerDesc': '시작하려면 회원가입하세요 !',
      'welcome': '환영합니다',
      'enterUsername' : '아이디...',
      'enterEmail' : '이메일...',
      'enterPassword' : '비밀번호...',
      'enterConfirmPassword' : '비밀번호 확인...',
      'forgotPassword': '비밀번호 찾기?',
      'anotherLogin' : '다른 로그인',
      'anotherRegister' : '다른 회원가입',
      'dontHaveAccount' : "계정이 없는 경우?",
      'alreadyHaveAccount' : "이미 계정니 있습니다?",
      'checkIn' : "체크 인",
      'checkOut' : "체크 아웃",
      'attendance' : "출석",
      'attendanceTitle' : "출석",
      'attendanceFor' : "사영자 출석",
      'attendanceType' : "출석 유형",
      'attendanceList' : "출석 목록",
      'scanAttendance' : "출석 스캔",
      'attendancePosted' : "출석 기록 완료",
      'attendancePostedDesc' : "출석 기록이 성공적으로 완료되었습니다 ",
      'attendanceFailed' : "출석 기록 실패",
      'attendanceFailedDesc' : "출석 기록을 올리지 못했습니다",
      'registered' : "등록됨",
      'registerFaceSuccess' : "얼굴 인식 성공적으로 등록",
      'notRegistered': "등록되지 않았습니다",
      'notRegistered3More' : "얼굴을 3번 등록해 주세요!",
      'registerAgain': "다시 등록하기",
      'register2More': "얼굴을 2번 더 등록해 주세요! ",
      'register1More': "얼굴을 1번 더 등록해 주세요!",
      'makeSureLocation' : "1. 출석 지역 또는 완제품 창고 지역 근처에 계십시오",
      'makeSureCamera' : "2. 효과적인 얼굴 감지를 위해 조명이 잘 되어 있는 환경에 계십시오",
      'youAre' : "당신은",
      'recognized' : "인식됨",
      'notRecognized' : "인식되지 않음",
      'faceRecognition' : "얼굴 인식",
      'noFaceFound' : "사용자 얼굴을 찾을 수 없습니다",
      'detect' : "인식",
      'pleaseWait' : "잠시 기다려주세요",
      'location' : "위치",
      'outsideArea' : "허용범위 밖 측정",
      'inTime' : "입장 후",
      'in' : "인",
      'out' : "아웃",
      'outTime' : "퇴근 후",
      'features' : "특징",
      'overtime' : "초과 근무",
      'overtimeList' : "초과 근무 목록",
      'editOvertime' : "초과 근무 수정",
      'addOvertime' : "초과 근무 추가",
      'overtimePosted' : "초과 근무가 게시됨",
      'overtimePostedDesc' : "초과 근무 요청이 성공적으로 게시되었습니다",
      'overtimeEdited' : "초과 근무가 편집됨",
      'overtimeEditedDesc' : "초과 근무 요청이 성공적으로 편집되었습니다",
      'rejectOvertime': "초과근무 요청을 성공적으로 거부했습니다",
      'rejectMakeSure': "거절하시겠습니까?",
      'approveOvertime': "초과근무 요청을 성공적으로 승인했습니다",
      'profile' : "프로필",
      'editProfile' : "프로필 수정",
      'department' : "부서",
      'performance' : "성과",
      'switchTheme' : "테마 변경",
      'current' : "지금",
      'language' : "언어",
      'seeAll' : "모두 보기",
      'search' : "검색",
      'yes' : "동의",
      'cancel' : "취소",
      'attention' : "경고 !",
      'name' : "이름",
      'from' : "시작",
      'until' : "까지",
      'remark' : "설명",
      'start' : "시작",
      'startTime' : "시작 날짜 선택",
      'end' : "끝",
      'endTime' : "종료일을 선택",
      'submit' : "보내",
      'save' : "저장",
      'requestFor' : "요구 사용자",
      'requested' : "요청됨",
      'reject' : "거절",
      'rejected' : "거부됨",
      'approve' : "승인",
      'approved' : "승인된 요구",
      'approvals' : "승인",
      'attendanceFeature' : "출석 기능",
      'overtimeFeature' : "초과 근무 기능",
      'leaveFeature' : "허가 기능",
      'approvalFeature' : "승인 기능",
      'checkpointTourFeature' : "체크포인 투어 기능",
      'monitoringFeature' : "모니터링 기능",
      'ticketingFeature' : "보고서 기능",
      'stockOpnameFeature' : "재고 조사 기능",
      'featureWarning' : "이 기능에 입장할 수 없습니다",
      'leaveList' : "허가 목록",
      'leaveType' : "허가 유형",
      'addLeave' : "유형 추가",
      'attachment' : "첨부 파일",
      'addFile' : "파일 추가",
      'time' : "시간 시작-끝",
      'viewPhoto' : "사진 보기",
      'priority' : "우선 순위",
      'category' : "카테고리",
      'subCategory' : "하위 카테고리",
      'status' : "상태",
      'addTicketing' : "보고서 추가",
      'ticketingList' : "보고서 목록",
      'ticketingDetail' : "보고서 상세 정보",
      'ticketingTo' : "보고서 사용자",
      'ticketingPosted' : "보고서 게시됨",
      'ticketingPostedDesc' : "보고서 성공적으로 게시되었습니다",
      'ticketingFailed' : "보고서 작성 실패",
      'ticketingFailedDesc' : "보고서 기록을 게시하지 못했습니다",
      'tryAgain' : "다시 시도",
      'attachmentCantEmpty' : "첨부 파일은 비워 둘 수 없습니다",
      'assignedTo' : "담당자",
      'subject' : "제목",
      'warehouse' : "창고",
      'warehouseFeature' : "창고 기능",
      'leave' : "허가",
      'checkpoinTour' : "체크포인 투어",
      'monitoring' : "모니터링",
      'stockopname' : "재고 조사",
      'patrolling' : "순찰",
      'done' : "완료",
      'chooseSite' : "장소 선택하세요",
      'january' : "1월",
      'february' : "2월",
      'march' : "3월",
      'april' : "4월",
      'may' : "5월",
      'june' : "6월",
      'jul' : "7월",
      'august' : "8월",
      'sept' : "9월",
      'okt' : "10월",
      'nov' : "11월",
      'des' : "12월",
      'exportexcel' : "엑셀 수출",
      'inputyear' : "입력 연도",
      'total' : "총",
      'productnumber': "제품 번호",
      'state' : "상태",
      'nodata' : "제품 데이터 없음",
      'postdraft' : "초안 게시",
      "surestock" : "재품고를 확인하시겠습니까?",
      'uploaded' : "보냈다",
      'succesupload' : "재품고가 성공적으로 보냈되었습니다.",
      'confirm' : "확인",
      'posted' : "게시됨",
      'draft' : "초안",
      'scanpatroll' : "순찰하려는 방의 QR 코드를 스캔하세요",
      'scan' : "스캔",
      'scanFailed' : "스캔 실패",
      'doNotScan' : "임의의 바코드를 스캔하지 마세요",
      'chooselocation' :"위치 선택",
      'scanlocation' : "위치 코드 스캔",
      'finish' : "끝",
      'barcodescanned': "바코드 스캔",
      'stocklist' : "재품고 목록",
      'stockform' : "주식 형태",
      'auditby' : "심사 기준",
      'lotnumber' : "로트 번호",
      'namabarang' : "제품 이름",
      'merk' : "브랜드",
      'stock' : "재고",
      'unit' : "단위",
      'upload' : "업로드",
      'add' : "더하다",
      'entermanually' : "수동으로 입력",
      'scanbarcode' : "바코드 스캔",
      'suredelete' : "삭제하시겠습니까",
      'sureLogOut' : "계정에서 로그아웃 하시겠습니까?",
      'refreshData': "데이터 새로고침",
      'noDataa': "데이터 없음",
      'doPicking': "창고 피킹",
      'truck': "트럭",
      'pack': "팩",
      'chooseTruck': "트럭 선택",
      'scanTruck': "트럭 스캔",
      'truckForm': "트럭 양식",
      'managedBy': "담당자",
      'next': "다음",
      'productForm': "제품 양식",
      'productList': "제품 목록",
      'addProduct': "제품 추가",
      'succesproductupload': "제품이 성공적으로 업로드되었습니다",
      'result': "결과",
      'ticketing' : "보고서",
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}
