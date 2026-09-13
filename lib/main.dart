import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const GZoneDashboardApp());

class GZoneDashboardApp extends StatelessWidget {
  const GZoneDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Club G-Zone',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12), // Fondo más profundo
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.tealAccent,
          surface: Colors.grey[900]!,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Puedes cambiarlo si usas Google Fonts
      ),
      home: const Scaffold(body: SafeArea(child: MainLayout())),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isLobby = true; // Controla si estamos en el inicio o viendo una sección
  Widget _currentView = const SizedBox();
  String _currentTitle = '';

  void _navigateTo(Widget view, String title) {
    setState(() {
      _currentView = view;
      _currentTitle = title;
      _isLobby = false; // Salimos del lobby
    });
  }

  void _backToLobby() {
    setState(() {
      _isLobby = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fondo vivo animado que envuelve toda la aplicación
    return _AnimatedGradientBackground(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _isLobby
            ? _LobbyView(onNavigate: _navigateTo) // Vista de inicio
            : _ContentView(
                // Vista de lectura con botón de regreso
                title: _currentTitle,
                view: _currentView,
                onBack: _backToLobby,
              ),
      ),
    );
  }
}

// =====================================================================
// NAVEGACIÓN Y ESTRUCTURA DEL LOBBY
// =====================================================================

// =====================================================================
// NAVEGACIÓN Y ESTRUCTURA DEL LOBBY
// =====================================================================

class _LobbyView extends StatelessWidget {
  final Function(Widget, String) onNavigate;

  const _LobbyView({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO CENTRAL ---
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/logo.png',
                height: 180, // Logo grande y centrado
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.shield,
                    color: Colors.orangeAccent,
                    size: 150,
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'BIENVENIDO A G-ZONE',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Selecciona tu destino',
              style: TextStyle(
                fontSize: 18,
                color: Colors.tealAccent.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 60),

            // --- BOTONES DEL LOBBY EN GRID ---
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: [
                _buildLobbyCard(
                  'El Códice',
                  'Reglas y Guía de Bienvenida',
                  Icons.menu_book,
                  Colors.deepPurpleAccent,
                  () => onNavigate(
                    const _GuiaBienvenidaView(),
                    'El Club / Guía de Bienvenida',
                  ),
                ),
                _buildLobbyCard(
                  'El Legado',
                  'Nuestra Misión y Propósito',
                  Icons.local_fire_department,
                  Colors.orangeAccent,
                  () => onNavigate(
                    const _PropuestaValorView(),
                    'El Club / Misión y Propósito',
                  ),
                ),
                _buildLobbyCard(
                  'Juegos de Mesa',
                  'Sede Presencial',
                  Icons.casino,
                  Colors.orange,
                  () => onNavigate(
                    const _ActividadPresencialView(
                      titulo: 'Juegos de Mesa',
                      subtitulo: 'Donde se forjan leyendas y se destruyen amistades (con cariño).',
                      descripcion: 'Nuestra área analógica para relajarte entre clases. Disfrutamos de partidas rápidas y juegos con cartas americanas de forma 100% recreativa (recuerda: las apuestas están prohibidas). Únete a una mesa libre y pasa el rato.',
                      icono: Icons.casino,
                      color: Colors.orange,
                      juegosDestacados: [
                        'UNO',
                        'Cartas',
                        'Conquián',
                        '21',
                        'Viuda',
                      ],
                    ),
                    'Presencial / Juegos de Mesa',
                  ),
                ),
                _buildLobbyCard(
                  'Torneos y Retas',
                  'Sede Presencial',
                  Icons.sports_esports,
                  Colors.redAccent,
                  () => onNavigate(
                    const _ActividadPresencialView(
                      titulo: 'Torneos y Retas (Consolas)',
                      subtitulo: 'El campo de batalla oficial de G-Zone.',
                      descripcion: 'El corazón competitivo del club. Armamos las retas en los salones para desestresarnos, definir quién es el mejor del campus o simplemente pasar el rato. Organizamos brackets para torneos internos y entrenamos duro.',
                      icono: Icons.sports_esports,
                      color: Colors.redAccent,
                      juegosDestacados: [
                        'Super Smash Bros',
                        'Mario Kart',
                        'KOF / Street Fighter',
                        'Mortal Kombat',
                        'Party Games',
                      ],
                    ),
                    'Presencial / Torneos Consolas',
                  ),
                ),
                _buildLobbyCard(
                  'Servidor Central',
                  'Discord & Bots',
                  Icons.discord,
                  const Color(0xFF5865F2),
                  () => onNavigate(
                    const _ActividadVirtualView(
                      titulo: 'Servidor Central',
                      subtitulo: 'Nuestra taberna digital y centro de mando.',
                      descripcion: 'La Taberna del Gremio en el canal #general es nuestro punto de encuentro. Contamos con una Gaming Zone (con un activo canal de #fortnite), zona de #anime-y-manga, y estadísticas en vivo. Nuestra experiencia y economía son gestionadas por nuestro escuadrón de bots. Conéctate a nuestras salas de voz (General, Música, Sala 1, 2, 3 o AFK) y mantén viva la comunidad.',
                      icono: Icons.dns,
                      color: Color(0xFF5865F2),
                      modulosDestacados: [
                        'AniGame (Cartas)',
                        'Tatsu (Niveles)',
                        'Mimu (Economía)',
                        'Carl & RB3 Guard',
                        'Rythm (Música)',
                        'ServerStats',
                      ],
                    ),
                    'Virtual / Servidor Central',
                  ),
                ),
                _buildLobbyCard(
                  'Proyecciones',
                  'Anime & Cultura',
                  Icons.tv,
                  Colors.pinkAccent,
                  () => onNavigate(
                    const _ActividadPresencialView(
                      titulo: 'Proyecciones Anime',
                      subtitulo: 'El cineclub geek de la universidad.',
                      descripcion: 'Aprovechamos las aulas y proyectores para compartir la cultura pop. Organizamos votaciones para los estrenos de la temporada, maratones de clásicos inolvidables y debates sobre manga. Prepara tus palomitas.',
                      icono: Icons.tv,
                      color: Colors.pinkAccent,
                      juegosDestacados: [
                        'Estrenos',
                        'Maratones Shonen',
                        'Debates de Manga',
                        'Clásicos',
                      ],
                    ),
                    'Presencial / Proyecciones Anime',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // La función ahora está correctamente FUERA del método build, pero DENTRO de la clase _LobbyView
  Widget _buildLobbyCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return _HoverableLobbyCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }
}

// =====================================================================
// WIDGET INTERACTIVO: TARJETAS CON ANIMACIÓN HOVER NEÓN
// =====================================================================
class _HoverableLobbyCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HoverableLobbyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_HoverableLobbyCard> createState() => _HoverableLobbyCardState();
}

class _HoverableLobbyCardState extends State<_HoverableLobbyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 250,
          height: 160,
          padding: const EdgeInsets.all(20),
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.05 : 1.0, // Escala en X (Ancho)
            _isHovered ? 1.05 : 1.0, // Escala en Y (Alto)
            1.0, // Escala en Z (Profundidad)
          ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withValues(alpha: _isHovered ? 1.0 : 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.color.withValues(alpha: _isHovered ? 0.8 : 0.3),
              width: _isHovered ? 3 : 2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 45, color: widget.color),
              const SizedBox(height: 15),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                widget.subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  final String title;
  final Widget view;
  final VoidCallback onBack;

  const _ContentView({
    required this.title,
    required this.view,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- BARRA SUPERIOR (HEADER Y BOTÓN ATRÁS) ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            border: Border(
              bottom: BorderSide(
                color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text('Volver al Lobby'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent.withValues(
                    alpha: 0.8,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.tealAccent,
                ),
              ),
            ],
          ),
        ),
        // --- ÁREA DE CONTENIDO ---
        Expanded(child: view),
      ],
    );
  }
}

// =====================================================================
// FONDO ANIMADO (EFECTO RESPIRACIÓN/GAMER)
// =====================================================================

class _AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const _AnimatedGradientBackground({required this.child});

  @override
  State<_AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<_AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // La animación dura 10 segundos de ida y 10 de vuelta
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Movemos los colores suavemente
              colors: [
                Color.lerp(
                  const Color(0xFF121212),
                  const Color(0xFF1A1A2E),
                  _controller.value,
                )!,
                Color.lerp(
                  const Color(0xFF0F0F1A),
                  const Color(0xFF23003A),
                  _controller.value,
                )!,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// =====================================================================
// WIDGETS DE VISTAS ESPECIALIZADAS (CÓDICE, LEGADO, ETC.)
// =====================================================================

/// Vista para el Propósito del Club (El Lore y el Legado)
class _PropuestaValorView extends StatelessWidget {
  const _PropuestaValorView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.orangeAccent.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  size: 60,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'El Legado G-Zone: Resurgiendo de las Cenizas',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(15),
                  border: Border(
                    left: BorderSide(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.8),
                      width: 5,
                    ),
                    right: BorderSide(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.8),
                      width: 5,
                    ),
                  ),
                ),
                child: Text(
                  'Hace 4 años, el club nació del sueño de unos amigos por compartir su pasión. Sin embargo, toda gran historia tiene su prueba de fuego. Tras una traición motivada por la ambición que dejó al club sin fondos y con el corazón roto, parecía el fin. Pero nos negamos a caer. El antiguo presidente tomó el manto, unió a los verdaderos fieles y resurgimos de nuestras cenizas.\n\nHoy, esa antorcha está en nuestras manos. Asumimos esta responsabilidad para honrar ese ideal puro: jugar, compartir y resistir. Somos el refugio definitivo de la universidad y no fallaremos a los que confiaron en nosotros.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[300],
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildPillarCard(
                        'Main Quest\n(Nuestra Misión)',
                        'Proteger el refugio. Mantener vivo este espacio de convivencia donde los videojuegos, el anime y los juegos de mesa sean la excusa perfecta para forjar amistades inquebrantables, sin importar los obstáculos académicos.',
                        Icons.shield,
                        Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildPillarCard(
                        'Endgame\n(Nuestra Visión)',
                        'Pasar la Antorcha. Garantizar que G-Zone sobreviva a cada generación. Mantendremos vivo este legado hasta encontrar a quienes compartan la misma pasión y responsabilidad para heredar el manto del club.',
                        Icons.sports_esports,
                        Colors.tealAccent,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildPillarCard(
                        'Atributos Base\n(Nuestros Valores)',
                        '• Resiliencia y Resistencia\n• Lealtad a la Tribu\n• Pasión Inquebrantable\n• Responsabilidad del Manto\n• Diversión Absoluta',
                        Icons.military_tech,
                        Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[850]?.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Vista estructurada para el Manual/Guía de Bienvenida (Códice G-Zone)
class _GuiaBienvenidaView extends StatelessWidget {
  const _GuiaBienvenidaView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      size: 40,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'El Códice G-Zone',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '4 años haciendo historia en la universidad',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.tealAccent,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(height: 1, color: Colors.grey[800], thickness: 2),
              const SizedBox(height: 30),
              Text(
                'A lo largo de cuatro generaciones, el Club G-Zone se ha consolidado como el epicentro de la cultura geek universitaria. Más que un grupo, somos una comunidad de veteranos y nuevos talentos unidos por los videojuegos, la tecnología, el anime y los juegos de tablero. Aquí encontrarás tu escuadrón, intercambiarás XP y descubrirás nuevos mundos. ¡Que inicie la partida!',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[350],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPanelBase(
                      'Fase Presencial (Aulas)',
                      Icons.map,
                      Column(
                        children: [
                          _buildHorarioTile(
                            'Lunes',
                            '3:00 PM – 5:00 PM',
                            'Salón 15C',
                            Colors.blueAccent,
                          ),
                          const SizedBox(height: 10),
                          _buildHorarioTile(
                            'Viernes',
                            '1:00 PM – 3:00 PM',
                            'Salón 3C',
                            Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildPanelBase(
                      'Red de Enlaces Oficiales',
                      Icons.link,
                      Column(
                        children: [
                          _buildLinkButton(
                            context,
                            'Servidor de Discord',
                            Icons.discord,
                            const Color(0xFF5865F2),
                            url: 'https://discord.gg/DQVa6daUAU',
                          ),
                          _buildLinkButton(
                            context,
                            'Registro Oficial del Club',
                            Icons.how_to_reg,
                            Colors.teal,
                            url: 'https://forms.gle/c4ZRWLt6Tnc3s53z8',
                          ),
                          _buildLinkButton(
                            context,
                            'Préstamo de Inventario',
                            Icons.inventory,
                            Colors.orange,
                            url: 'https://docs.google.com/forms/d/e/1FAIpQLSeZovKraLqwgQBe34_CS9SWGKqPniyiXejLTb10PQhWme2LYg/viewform',
                          ),
                          _buildLinkButton(
                            context,
                            'Realm de Minecraft (Inactivo)',
                            Icons.landscape,
                            Colors.grey,
                            url: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Icon(Icons.gavel, color: Colors.redAccent, size: 28),
                  SizedBox(width: 15),
                  Text(
                    'Reglamento Oficial Operativo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRule(
                '1. Respeto Absoluto (PvE, no PvP tóxico)',
                'Todos los miembros deben tratarse con respeto. Cero tolerancia a insultos, ataques personales, acoso o discriminación.',
                Icons.handshake,
              ),
              _buildRule(
                '2. Enfoque Geek',
                'Comparte temas relacionados con videojuegos, tecnología, anime o afines. Nada de spam ni desvíos excesivos del tema.',
                Icons.sports_esports,
              ),
              _buildRule(
                '3. Chat de Voz y Texto Limpio',
                'Mantén un lenguaje apropiado y constructivo. La pasión por el juego no justifica la agresión verbal.',
                Icons.forum,
              ),
              _buildRule(
                '4. Zona Libre de Spoilers',
                'Si vas a hablar de la trama (lore) de un juego o serie reciente, usa etiquetas de spoiler o avisa con antelación.',
                Icons.warning_amber,
              ),
              _buildRule(
                '5. Multijugador Cooperativo',
                'Este es un espacio para aprender y mejorar juntos. ¡Apoya a los miembros que necesiten ayuda con una misión o configuración!',
                Icons.group_add,
              ),
              _buildRule(
                '6. Sin Microtransacciones (Cero Publicidad)',
                'Prohibido promocionar productos, ventas o servicios externos sin la autorización expresa del staff.',
                Icons.block,
              ),
              _buildRule(
                '7. Control de Spam y Latencia',
                'Evita saturar los canales con mensajes repetitivos, cadenas o multimedia masiva que rompa el flujo de la conversación.',
                Icons.speed,
              ),
              _buildRule(
                '8. Resolución Pacífica',
                'Cualquier conflicto entre miembros se resolverá con diálogo y respeto. Los administradores actuarán como árbitros neutrales si es requerido.',
                Icons.balance,
              ),
              _buildRule(
                '9. Sistema de Strikes (Sanciones)',
                'Romper el códice acumulará advertencias. Un máximo de 3 "strikes" resultará en la expulsión permanente de la sesión (Kick/Ban).',
                Icons.do_not_disturb_on,
              ),
              const SizedBox(height: 50),
              const Center(child: AnimatedAcceptButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelBase(String title, IconData icon, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurpleAccent),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _buildHorarioTile(String dia, String hora, String lugar, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dia,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    hora,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          Chip(
            label: Text(
              lugar,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: color.withValues(alpha: 0.2),
            side: BorderSide.none,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color, {
    String? url,
  }) {
    final bool isInactive = url == null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            if (isInactive) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Este enlace está inactivo.'),
                  backgroundColor: Colors.grey,
                ),
              );
              return;
            }
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              // Verificamos si la pantalla sigue activa antes de usar el context
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No se pudo abrir el enlace: $url')),
              );
            }
          },
          icon: Icon(icon, color: Colors.white, size: 18),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isInactive
                ? Colors.grey[800]
                : color.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRule(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.tealAccent, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[400],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedAcceptButton extends StatefulWidget {
  const AnimatedAcceptButton({super.key});
  @override
  State<AnimatedAcceptButton> createState() => _AnimatedAcceptButtonState();
}

class _AnimatedAcceptButtonState extends State<AnimatedAcceptButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.6),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Códice aceptado! Bienvenido a la partida.'),
                backgroundColor: Colors.teal,
              ),
            );
          },
          icon: const Icon(Icons.check_circle, size: 24),
          label: const Text('He leído y acepto el Códice G-Zone'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vista Especializada para la Sede Presencial
class _ActividadPresencialView extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String descripcion;
  final IconData icono;
  final Color color;
  final List<String> juegosDestacados;

  const _ActividadPresencialView({
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.juegosDestacados,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border(bottom: BorderSide(color: color, width: 6)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icono, size: 70, color: color),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitulo,
                            style: TextStyle(
                              fontSize: 18,
                              color: color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dinámica de la División',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          descripcion,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.local_play,
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Roster Principal',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: juegosDestacados.map((juego) {
                              return Chip(
                                label: Text(
                                  juego,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: color.withValues(alpha: 0.2),
                                side: BorderSide(
                                  color: color.withValues(alpha: 0.5),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Vista Especializada para la Sede Virtual
class _ActividadVirtualView extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String descripcion;
  final IconData icono;
  final Color color;
  final List<String> modulosDestacados;

  const _ActividadVirtualView({
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.modulosDestacados,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border(bottom: BorderSide(color: color, width: 6)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icono, size: 70, color: color),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitulo,
                            style: TextStyle(
                              fontSize: 18,
                              color: color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Infraestructura Digital',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          descripcion,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.memory,
                                color: Colors.tealAccent,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Módulos Activos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: modulosDestacados.map((modulo) {
                              return Chip(
                                label: Text(
                                  modulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: color.withValues(alpha: 0.2),
                                side: BorderSide(
                                  color: color.withValues(alpha: 0.5),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
