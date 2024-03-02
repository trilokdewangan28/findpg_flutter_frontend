class ApiLinks{

 // V20q3-71F9tTvUm-3_dRZPHIBhnVMQRLpOfjsWrE
  static  const baseUrl = "http://192.168.0.144:3000/";

  //----------------------------GUEST API's------------------------------------
  static const guestProfileApi='${baseUrl}guestApi/guestProfile';
  static const registerGuestApi='${baseUrl}guestApi/registerGuest';
  static const loginGuestApi='${baseUrl}guestApi/loginGuest';
  static const updateGuestApi='${baseUrl}guestApi/updateGuest';
  static const deleteGuestApi='${baseUrl}guestApi/deleteGuest';

  static const sendVerificationMailForGuest = '${baseUrl}guestApi/sendVerificationMailForGuest';
  static const verifyOtpForGuest = '${baseUrl}guestApi/verifyOtpForGuest';

  static const uploadGuestProfilePicApi='${baseUrl}guestApi/uploadGuestProfilePic';
  static const accessGuestProfilePicApi='${baseUrl}guestApi/accessGuestProfilePic';
  static const updateGuestProfilePicApi='${baseUrl}guestApi/uploadGuestProfilePic';
  static const deleteGuestProfilePicApi='${baseUrl}guestApi/deleteGuestProfilePic';

  static const fetchBookedGuestDetailsApi='${baseUrl}guestApi/fetchBookedGuestDetails';

  static const sendOtpForgotPasswordForGuest = '${baseUrl}guestApi/sendOtpForgotPasswordForGuest';
  static const verifyOtpAndUpdatePasswordForGuest = '${baseUrl}guestApi/verifyOtpAndUpdatePasswordForGuest';

  //----------------------------OWNER API's-------------------------------------
  static const ownerProfileApi='${baseUrl}ownerApi/ownerProfile';
  static const registerOwnerApi='${baseUrl}ownerApi/registerOwner';
  static const loginOwnerApi='${baseUrl}ownerApi/loginOwner';
  static const updateOwnerApi='${baseUrl}ownerApi/updateOwner';
  static const deleteOwnerApi='${baseUrl}ownerApi/deleteOwner';

  static const sendVerificationMailForOwner = '${baseUrl}ownerApi/sendVerificationMailForOwner';
  static const verifyOtpForOwner = '${baseUrl}ownerApi/verifyOtpForOwner';

  static const uploadOwnerHostlePicApi='${baseUrl}ownerApi/uploadOwnerHostlePic';
  static const deleteOwnerHostlePicApi='${baseUrl}ownerApi/deleteOwnerHostlePic';

  static const uploadOwnerProfilePicApi='${baseUrl}ownerApi/uploadOwnerProfilePic';
  static const accessOwnerProfilePicApi='${baseUrl}ownerApi/accessOwnerProfilePic';
  static const updateOwnerProfilePicApi='${baseUrl}ownerApi/uploadOwnerProfilePic';
  static const deleteOwnerProfilePicApi='${baseUrl}ownerApi/deleteOwnerProfilePic';

  static const fetchTheRateApi = '${baseUrl}ownerApi/fetchTheRate';
  static const rateTheOwnerApi = '${baseUrl}ownerApi/rateTheOwner';

  static const unbookGuestForOwner = '${baseUrl}ownerApi/unbookGuestForOwner';

  static const sendOtpForgotPasswordForOwner = '${baseUrl}ownerApi/sendOtpForgotPasswordForOwner';
  static const verifyOtpAndUpdatePasswordForOwner = '${baseUrl}ownerApi/verifyOtpAndUpdatePasswordForOwner';

  //----------------------------HOSTELS API's-----------------------------------
  static const fetchHostleApi='${baseUrl}hostleApi/fetchHostle';
  static const accessHostleImages='${baseUrl}hostleApi/accessHostleImages';
  static const bookHostleApi='${baseUrl}hostleApi/bookHostle';
  static const unBookHostleApi='${baseUrl}hostleApi/unBookHostle';
  static const sendOtpForBookApi = '${baseUrl}hostleApi/sendOtpForBook';
  static const verifyOtpAndBook = '${baseUrl}hostleApi/verifyOtpAndBook';
  static const sendOtpForUnbookApi = '${baseUrl}hostleApi/sendOtpForUnbook';
  static const verifyOtpAndUnbookApi='${baseUrl}hostleApi/verifyOtpAndUnbook';

  //-----------------------------ACCOUNT API'S----------------------------------
  static const sendOtpForAccountTransaction = '${baseUrl}accountApi/sendOtp';
  static const markedAsPaid = '${baseUrl}accountApi/markedAsPaid';
  static const fetchPaymentRecord = '${baseUrl}accountApi/fetchPaymentRecord';





}