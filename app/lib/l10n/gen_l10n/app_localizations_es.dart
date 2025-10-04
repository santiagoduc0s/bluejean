// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Bus Escolares';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get home => 'Inicio';

  @override
  String get name => 'Nombre';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get email => 'Correo electrónico';

  @override
  String get automatic => 'Automático';

  @override
  String get system => 'Sistema';

  @override
  String get save => 'Guardar';

  @override
  String get or => 'O';

  @override
  String get biometric => 'Biométrico';

  @override
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get always => 'Siempre';

  @override
  String get never => 'Nunca';

  @override
  String get search => 'Buscar';

  @override
  String get skip => 'Saltar';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get done => 'Hecho';

  @override
  String get loading => 'Cargando';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Reintentar';

  @override
  String get dismiss => 'Descartar';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get edit => 'Editar';

  @override
  String get add => 'Añadir';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get goBack => 'Volver';

  @override
  String get close => 'Cerrar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get change => 'Cambiar';

  @override
  String get gotIt => 'Entendido';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rechazar';

  @override
  String get enable => 'Habilitar';

  @override
  String get disable => 'Deshabilitar';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get termsAndConditions => 'Términos y Condiciones';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get update => 'Actualizar';

  @override
  String get readMore => 'Leer más';

  @override
  String get readLess => 'Leer menos';

  @override
  String get join => 'Unirse';

  @override
  String get keyboard => 'Teclado';

  @override
  String get markAsRead => 'Marcar como leído';

  @override
  String get markAsUnread => 'Marcar como no leído';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get markAllAsRead => 'Marcar todo como leído';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get noNotifications => 'No hay notificaciones';

  @override
  String get empty => 'Vacios';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse con email';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get send => 'Enviar';

  @override
  String get open => 'Abrir';

  @override
  String get camera => 'Camara';

  @override
  String get gallery => 'Galería';

  @override
  String get takePicture => 'Tomar foto';

  @override
  String get deletePicture => 'Eliminar foto';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get password => 'Contraseña';

  @override
  String get repeatPassword => 'Repetir contraseña';

  @override
  String get forgotMyPassword => 'Olvidé mi contraseña';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get signInWithFacebook => 'Iniciar sesión con Facebook';

  @override
  String get connected => 'Conectado';

  @override
  String get notConnected => 'Sin conexión';

  @override
  String get generalError => 'Ocurrió un error.';

  @override
  String get contactSupport => 'Contactar soporte';

  @override
  String home_welcomeUser(String name) {
    return 'Hola, $name';
  }

  @override
  String get forgotPassword_emailSent =>
      'Se envió un correo para restablecer la contraseña';

  @override
  String get forgotPassword_title => 'Recuperar contraseña';

  @override
  String get profile_userUpdated => 'Perfil actualizado con éxito';

  @override
  String get profile_messageActivePermission =>
      'Necesitamos tu permiso para usar la cámara';

  @override
  String get profile_imageUpdated => 'Imagen actualizada con éxito';

  @override
  String get profile_imageDeleted => 'Imagen eliminada con éxito';

  @override
  String get signIn_emailDoesNotVerified =>
      'Por favor, valida tu correo para continuar';

  @override
  String get signIn_invalidCredential => 'Verifica tus credenciales';

  @override
  String get signIn_wrongPassword => 'Contraseña incorrecta';

  @override
  String get signIn_userDisabled => 'Usuario deshabilitado';

  @override
  String get signIn_emailValidationSent =>
      'Hemos enviado un correo para validar tu cuenta';

  @override
  String get signUp_emailAlreadyInUse => 'El correo ya está en uso';

  @override
  String get signUp_weakPassword => 'La contraseña es demasiado débil';

  @override
  String get signUp_InvalidEmailFormat => 'El correo es inválido';

  @override
  String get lock_title => 'La app está bloqueada';

  @override
  String get lock_description => 'Por favor, desbloquea la app para continuar';

  @override
  String get lock_button => 'Desbloquear';

  @override
  String get lock_message => 'Autentícate para desbloquear la app';

  @override
  String get settings_titleConfirmDeleteAccount =>
      'Esta acción es irreversible';

  @override
  String get settings_messageConfirmDeleteAccount =>
      'Antes de eliminar tu cuenta, debes reautenticarte';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_languageSpanish => 'Español';

  @override
  String get settings_languageEnglish => 'Inglés';

  @override
  String get settings_resetPassword => 'Cambiar contraseña';

  @override
  String get settings_newPassword => 'Nueva contraseña';

  @override
  String get settings_passwordUpdated => 'Contraseña actualizada con éxito';

  @override
  String get settings_checkPassword => 'Verifica la contraseña actual';

  @override
  String get validation_any =>
      'Al menos uno de los campos obligatorios debe estar lleno.';

  @override
  String get validation_compare => 'Los campos deben coincidir.';

  @override
  String get validation_contains =>
      'La entrada debe contener el valor requerido.';

  @override
  String get validation_creditCard =>
      'Por favor, introduce un número de tarjeta de crédito válido.';

  @override
  String get validation_email =>
      'Por favor, introduce una dirección de correo electrónico válida.';

  @override
  String get validation_equals => 'Los valores no coinciden.';

  @override
  String validation_max(num max) {
    return 'El valor debe ser menor o igual a $max.';
  }

  @override
  String validation_maxLength(int max) {
    return 'La longitud máxima es de $max caracteres.';
  }

  @override
  String validation_min(num min) {
    return 'El valor debe ser mayor o igual a $min.';
  }

  @override
  String validation_minLength(int min) {
    return 'La longitud mínima es de $min caracteres.';
  }

  @override
  String get validation_mustMatch => 'Los campos deben coincidir.';

  @override
  String get validation_number => 'Por favor, introduce un número válido.';

  @override
  String get validation_pattern =>
      'La entrada no coincide con el patrón requerido.';

  @override
  String get validation_required => 'Este campo es obligatorio.';

  @override
  String get validation_requiredTrue => 'Este campo debe ser seleccionado.';

  @override
  String get exception_credentialAlreadyExists =>
      'Ya existe una cuenta con este correo';

  @override
  String get biometricSwitcher_activate => 'Activar biométrico';

  @override
  String get biometricSwitcher_activateConfirmation =>
      '¿Deseas activar la biométrico?';

  @override
  String get biometricSwitcher_deactivate => 'Desactivar biométrico';

  @override
  String get biometricSwitcher_deactivateConfirmation =>
      '¿Deseas desactivar la biométrico?';

  @override
  String get biometricSwitcher_activateAuthReason =>
      'Autentícate para activar la biométrico';

  @override
  String get biometricSwitcher_deactivateAuthReason =>
      'Autentícate para desactivar la biométrico';

  @override
  String get biometricSwitcher_notSupported =>
      'Tu dispositivo no admite biométrico';

  @override
  String get biometricSwitcher_every15Seconds => 'Cada 15 segundos';

  @override
  String get biometricSwitcher_every30Seconds => 'Cada 30 segundos';

  @override
  String get biometricSwitcher_everyMinute => 'Cada minuto';

  @override
  String get biometricSwitcher_every2Minutes => 'Cada 2 minutos';

  @override
  String get biometricSwitcher_every5Minutes => 'Cada 5 minutos';

  @override
  String get biometricSwitcher_every15Minutes => 'Cada 15 minutos';

  @override
  String get biometricSwitcher_everyHour => 'Cada hora';

  @override
  String get biometricSwitcher_everyDay => 'Cada día';

  @override
  String get home_title => 'Título';

  @override
  String get home_subTitle => 'Calcula tu tiempo restante';

  @override
  String get calculate => 'Calcular';

  @override
  String get enter_birthday => 'Introduce tu cumpleaños';

  @override
  String get onboard_title => 'Asistente de Ruta de Autobús';

  @override
  String get onboard_description =>
      'Conduce tu ruta de autobús escolar mientras la aplicación notifica automáticamente a los padres cuando te acercas a sus puntos de recogida. Comunicación simple y sin intervención manual para conductores.';

  @override
  String get onboard_start => 'Comenzar';

  @override
  String get systemDefault => 'Sistema por defecto';

  @override
  String get legal => 'Legal';

  @override
  String get termsOfService => 'Términos del servicio';

  @override
  String get goToSettings => 'Ir a Configuraciones';

  @override
  String get appearance => 'Apariencia';

  @override
  String get galleryIsDisabled =>
      'El acceso a la galería está deshabilitado, ¿quieres habilitarlo?';

  @override
  String get cameraIsDisabled =>
      'El acceso a la cámara está deshabilitado, ¿quieres habilitarlo?';

  @override
  String get notificationsAreDisabled =>
      'Las notificaciones están deshabilitadas, ¿quieres habilitarlas?';

  @override
  String get deleteAccountMessage =>
      '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.';

  @override
  String get support => 'Soporte';

  @override
  String get submit => 'Enviar';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descripción';

  @override
  String get options => 'Opciones';

  @override
  String get supportDescription =>
      'Por favor, proporciona una descripción detallada de tu problema o pregunta. Nuestro equipo de soporte te ayudará lo antes posible.';

  @override
  String get ticketCreated => 'Ticket creado con éxito';

  @override
  String get attachImages => 'Adjuntar Imágenes';

  @override
  String get maxImages => 'Máximo de imágenes';

  @override
  String get invalidPassword => 'La contraseña es inválida';

  @override
  String get enterPassword => 'Introduce tu contraseña';

  @override
  String get iWantIt => '¡Quiero!';

  @override
  String get confirmSignInNotification =>
      'Para enviar notificaciones debes estar autenticado ¿Quieres iniciar sesión?';

  @override
  String get confirmSignInProfile =>
      'Para acceder a tu perfil debes estar autenticado ¿Quieres iniciar sesión?';

  @override
  String get manageDevices => 'Administrar dispositivos';

  @override
  String get deleteAllDevices => 'Eliminar Todos los Dispositivos';

  @override
  String get deleteAllDevicesConfirmation =>
      '¿Estás seguro de que quieres eliminar todos los dispositivos? Esta acción no se puede deshacer.';

  @override
  String get noDevicesFound => 'No se encontraron dispositivos';

  @override
  String get deleteDevice => 'Eliminar Dispositivo';

  @override
  String get deleteDeviceConfirmation =>
      '¿Estás seguro de que quieres eliminar este dispositivo?';

  @override
  String get deleteCurrentDeviceWarning =>
      'Este es tu dispositivo actual. Se cerrará tu sesión.';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get createCompany => 'Crear Empresa';

  @override
  String get companyName => 'Nombre de la Empresa';

  @override
  String get createChannel => 'Crear Canal';

  @override
  String get myCompany => 'Mi Empresa';

  @override
  String get noCompaniesFound => 'No se encontraron empresas';

  @override
  String get channelName => 'Nombre del Canal';

  @override
  String get channelCreated => 'Canal creado exitosamente';

  @override
  String get listeners => 'Oyentes';

  @override
  String get addListener => 'Agregar Oyente';

  @override
  String get editListener => 'Editar Oyente';

  @override
  String get deleteListener => 'Eliminar Oyente';

  @override
  String deleteListenerConfirmation(String listenerName) {
    return '¿Estás seguro de que quieres eliminar a \"$listenerName\"?';
  }

  @override
  String get noListenersAdded => 'No se han agregado oyentes aún';

  @override
  String get phoneNumberIsRequired => 'El número de teléfono es requerido';

  @override
  String get phoneNumberInvalidFormat =>
      'El número debe estar en formato internacional +1234567890 (código de país + número, sin espacios)';

  @override
  String get address => 'Dirección';

  @override
  String get setOnMap => 'Ubicar en Mapa';

  @override
  String get selectLocation => 'Seleccionar Ubicación';

  @override
  String get dragMarkerToSelectLocation =>
      'Arrastra el marcador para seleccionar una ubicación';

  @override
  String get dragMapToSelectLocation =>
      'Arrastra el mapa para seleccionar una ubicación';

  @override
  String get clear => 'Limpiar';

  @override
  String get listenerName => 'Nombre del Oyente';

  @override
  String get phoneNumber => 'Número de Teléfono';

  @override
  String get distanceToNotify => 'Distancia para Notificar (metros)';

  @override
  String get location => 'Ubicación';

  @override
  String get removeListener => 'Eliminar Oyente';

  @override
  String get importFromContacts => 'Importar de Contactos';

  @override
  String get profileEmailNote =>
      'Este email no es tu email de autenticación, solo es para información';

  @override
  String get deviceDeletedSuccessfully => 'Dispositivo eliminado exitosamente';

  @override
  String get editChannel => 'Editar Canal';

  @override
  String get enterChannelName => 'Ingresa el nombre del canal';

  @override
  String get enterChannelDescription =>
      'Ingresa la descripción del canal (opcional)';

  @override
  String get nameIsRequired => 'El nombre es requerido';

  @override
  String get create => 'Crear';

  @override
  String get deleteChannel => 'Eliminar Canal';

  @override
  String deleteChannelConfirmation(String channelName) {
    return '¿Estás seguro de que quieres eliminar \"$channelName\"?';
  }

  @override
  String get noChannelsFound =>
      'No se encontraron canales. ¡Crea uno usando el botón +!';

  @override
  String get searchingLocation => 'Buscando ubicación...';

  @override
  String get locationFound => 'Ubicación encontrada';

  @override
  String get typeAddressForLocation =>
      'Escribe la dirección para encontrar coordenadas';

  @override
  String get status => 'Estado';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String get activeChannels => 'Canales Activos';

  @override
  String get inactiveChannels => 'Canales Inactivos';

  @override
  String get activeChannelsSubtitle =>
      'Los oyentes de estos canales serán notificados cuando el automóvil esté cerca de su ubicación';

  @override
  String get inactiveChannelsSubtitle =>
      'Estos canales están deshabilitados y el modo de conducción necesita ser actualizado';

  @override
  String get information => 'Información';

  @override
  String get threshold => 'Umbral';

  @override
  String get errorLoadingNotifications => 'Error al cargar notificaciones';

  @override
  String get noNotificationsFound => 'No se encontraron notificaciones';

  @override
  String get notificationsWillAppearHere =>
      'Las notificaciones aparecerán aquí cuando el autobús esté cerca de la ubicación de este oyente';

  @override
  String get coordinates => 'Coordenadas';

  @override
  String get tutorialLocationTitle => 'Rastreo de Ubicación';

  @override
  String get tutorialLocationDescription =>
      'Presiona este botón para activar tu ubicación. Los oyentes de los canales activados serán notificados cuando estés cerca de ellos.';

  @override
  String get tutorialAddChannelTitle => 'Agregar Canal';

  @override
  String get tutorialAddChannelDescription =>
      'Presiona este botón para crear un nuevo canal. Los canales te ayudan a organizar tus oyentes por rutas o grupos.';

  @override
  String get tutorialGotIt => '¡Entendido!';

  @override
  String get webKeyFeatures => 'Características Principales';

  @override
  String get webSimpleRouteDriving => 'Conducción de Ruta Simple';

  @override
  String get webSimpleRouteDrivingDescription =>
      'Solo conduce tu ruta normalmente - la aplicación maneja todo automáticamente en segundo plano';

  @override
  String get webHandsFreeOperation => 'Operación Sin Intervención Manual';

  @override
  String get webHandsFreeOperationDescription =>
      'Cuando te acercas a los puntos de recogida de estudiantes, los padres son notificados automáticamente - no necesitas hacer nada';

  @override
  String get webEasyRouteSetup => 'Configuración Fácil de Ruta';

  @override
  String get webEasyRouteSetupDescription =>
      'Configura los puntos de recogida de estudiantes una vez, luego solo conduce - la aplicación hace el resto';

  @override
  String webCopyright(String appName) {
    return '© 2025 $appName. Todos los derechos reservados.';
  }

  @override
  String get locationTrackingNotificationTitle => 'Rastreando Ubicación';

  @override
  String get locationTrackingNotificationText =>
      'Bus Escolares está rastreando la ubicación del autobús';

  @override
  String get webHowToUse => 'Comienza en segundos';

  @override
  String get webHowToUseDescription =>
      'Aprende cómo configurar y usar Bus Escolares con nuestros videos tutoriales simples. Comienza creando canales, agregando oyentes y rastreando tus rutas.';
}
