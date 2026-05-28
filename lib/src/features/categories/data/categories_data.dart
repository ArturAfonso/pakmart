import 'package:flutter/material.dart';
import 'package:pakmart/src/features/categories/models/categories_model.dart';

abstract final class CategoriesData {
  static const categories = [
    CategoryData(
      id: 'office',
      title: 'Escritório',
      description: 'Documentos, planilhas e produtividade',
      icon: Icons.description_outlined,
      iconColor: Color(0xFF6FA3FF),
      apps: [
        CategoryAppData(
          id: 'flowstudio',
          name: 'FlowStudio',
          publisher: 'Atelier Open',
          rating: 4.9,
          ratingCountLabel: '(2.430)',
          downloadsLabel: '410k downloads',
          categoryLabel: 'Office',
          icon: Icons.brush_rounded,
          iconBackground: Color(0xFFFFE3DA),
          tagline: 'Escrita focada, silenciosa e pronta para longas sessões.',
          about: 'Editor limpo para documentos longos, notas estruturadas e exportação em PDF ou Markdown.',
          version: '3.2.1',
          size: '84.2 MB',
          license: 'GPL-3.0',
          flatpakId: 'art.atelier.FlowStudio',
        ),
        CategoryAppData(
          id: 'obsidiana',
          name: 'Obsidiana',
          publisher: 'Marble Notes',
          rating: 4.9,
          ratingCountLabel: '(8.120)',
          downloadsLabel: '1.2M downloads',
          categoryLabel: 'Office',
          icon: Icons.auto_awesome_rounded,
          iconBackground: Color(0xFFD8EEFF),
          tagline: 'Notas conectadas com mapas mentais e blocos reutilizáveis.',
          about: 'Organize conhecimento, conecte ideias e publique documentos com uma base local e leve.',
          version: '1.7.3',
          size: '118 MB',
          license: 'MIT',
          flatpakId: 'io.marble.Obsidiana',
        ),
      ],
    ),
    CategoryData(
      id: 'multimedia',
      title: 'Multimídia',
      description: 'Áudio, vídeo e tocadores',
      icon: Icons.music_note_rounded,
      iconColor: Color(0xFF6A8595),
      apps: [
        CategoryAppData(
          id: 'echo-player',
          name: 'Echo Player',
          publisher: 'FM Harmony',
          rating: 4.8,
          ratingCountLabel: '(4.220)',
          downloadsLabel: '780k downloads',
          categoryLabel: 'Music',
          icon: Icons.headphones_rounded,
          iconBackground: Color(0xFFE3E8FF),
          tagline: 'Player acolhedor para biblioteca local, rádio e podcasts.',
          about: 'Escute coleções offline, filas inteligentes e podcasts sincronizados entre dispositivos.',
          version: '2.4.1',
          size: '142.5 MB',
          license: 'MPL-2.0',
          flatpakId: 'fm.harmony.Echo',
        ),
        CategoryAppData(
          id: 'cinewave',
          name: 'CineWave',
          publisher: 'Open Motion',
          rating: 4.6,
          ratingCountLabel: '(1.930)',
          downloadsLabel: '220k downloads',
          categoryLabel: 'Video',
          icon: Icons.movie_creation_outlined,
          iconBackground: Color(0xFFE5F0FF),
          tagline: 'Catálogo local e streaming para vídeo em alta definição.',
          about: 'Gerencie filmes e séries com metadados automáticos, listas e reprodução contínua.',
          version: '5.1.0',
          size: '189 MB',
          license: 'Apache-2.0',
          flatpakId: 'org.openmotion.CineWave',
        ),
      ],
    ),
    CategoryData(
      id: 'games',
      title: 'Jogos',
      description: 'Diversão e entretenimento',
      icon: Icons.casino_outlined,
      iconColor: Color(0xFF8F8F8F),
      apps: [
        CategoryAppData(
          id: 'aster-cube',
          name: 'Aster Cube',
          publisher: 'Northplay',
          rating: 4.5,
          ratingCountLabel: '(910)',
          downloadsLabel: '95k downloads',
          categoryLabel: 'Games',
          icon: Icons.sports_esports_outlined,
          iconBackground: Color(0xFFF0E7FF),
          tagline: 'Quebra-cabeças rápidos em arenas geométricas e neon.',
          about: 'Partidas curtas, desafios progressivos e trilha eletrônica para sessões casuais.',
          version: '0.9.8',
          size: '312 MB',
          license: 'Proprietary',
          flatpakId: 'games.northplay.AsterCube',
          verified: false,
        ),
        CategoryAppData(
          id: 'canyon-run',
          name: 'Canyon Run',
          publisher: 'Trailbyte',
          rating: 4.3,
          ratingCountLabel: '(620)',
          downloadsLabel: '54k downloads',
          categoryLabel: 'Games',
          icon: Icons.rocket_launch_outlined,
          iconBackground: Color(0xFFFFE9DF),
          tagline: 'Corridas arcade por desfiladeiros e desertos proceduralmente gerados.',
          about: 'Percursos curtos, desbloqueios cosméticos e suporte a controle para desktop.',
          version: '1.3.4',
          size: '426 MB',
          license: 'Proprietary',
          flatpakId: 'games.trailbyte.CanyonRun',
          verified: false,
        ),
      ],
    ),
    CategoryData(
      id: 'development',
      title: 'Desenvolvimento',
      description: 'Editores, IDEs e ferramentas',
      icon: Icons.handyman_outlined,
      iconColor: Color(0xFF7D9DB5),
      apps: [
        CategoryAppData(
          id: 'vscodium',
          name: 'VSCodium',
          publisher: 'VSCodium',
          rating: 4.8,
          ratingCountLabel: '(15.800)',
          downloadsLabel: '2.8M downloads',
          categoryLabel: 'Development',
          icon: Icons.keyboard_rounded,
          iconBackground: Color(0xFFD7F5FF),
          tagline: 'Editor aberto e enxuto para desenvolvimento diário.',
          about: 'Ambiente moderno para programação com extensões, terminal integrado e telemetria removida.',
          version: '1.92.0',
          size: '320 MB',
          license: 'MIT',
          flatpakId: 'com.vscodium.codium',
        ),
      ],
    ),
    CategoryData(
      id: 'internet',
      title: 'Internet',
      description: 'Navegadores, e-mail e chat',
      icon: Icons.spa_outlined,
      iconColor: Color(0xFF71B44C),
      apps: [
        CategoryAppData(
          id: 'teleframe',
          name: 'Teleframe',
          publisher: 'Frame Labs',
          rating: 4.7,
          ratingCountLabel: '(5.040)',
          downloadsLabel: '830k downloads',
          categoryLabel: 'Chat',
          icon: Icons.chat_bubble_outline_rounded,
          iconBackground: Color(0xFFD9F7FF),
          tagline: 'Mensageria rápida com sincronização nativa em desktop.',
          about: 'Converse com grupos, chamadas leves e histórico sincronizado entre sessões.',
          version: '2.4.1',
          size: '98 MB',
          license: 'AGPL-3.0',
          flatpakId: 'im.frame.Teleframe',
        ),
        CategoryAppData(
          id: 'north-browser',
          name: 'North Browser',
          publisher: 'Luma Web',
          rating: 4.4,
          ratingCountLabel: '(1.210)',
          downloadsLabel: '300k downloads',
          categoryLabel: 'Browser',
          icon: Icons.public_rounded,
          iconBackground: Color(0xFFE6F8EA),
          tagline: 'Navegador veloz com foco em privacidade e sincronização.',
          about: 'Perfis, abas fixas, bloqueio de rastreadores e favoritos sincronizados com a nuvem.',
          version: '6.0.2',
          size: '204 MB',
          license: 'BSD-3-Clause',
          flatpakId: 'web.luma.NorthBrowser',
        ),
      ],
    ),
    CategoryData(
      id: 'graphics',
      title: 'Gráficos',
      description: 'Ilustração, edição e design',
      icon: Icons.palette_outlined,
      iconColor: Color(0xFFF2A24D),
      apps: [
        CategoryAppData(
          id: 'vivid-studio',
          name: 'Vivid Studio',
          publisher: 'Brushwood',
          rating: 4.7,
          ratingCountLabel: '(5.320)',
          downloadsLabel: '950k downloads',
          categoryLabel: 'Graphics',
          icon: Icons.brush_rounded,
          iconBackground: Color(0xFFFFE5F4),
          tagline: 'Ilustração vetorial profissional, agora nativa em Wayland.',
          about: 'Pincéis pressuráveis, camadas infinitas, exportação em SVG, PDF e PNG.',
          version: '5.0.0',
          size: '210 MB',
          license: 'MIT',
          flatpakId: 'studio.brushwood.Vivid',
        ),
        CategoryAppData(
          id: 'gimp',
          name: 'GIMP',
          publisher: 'GIMP Team',
          rating: 4.6,
          ratingCountLabel: '(14.200)',
          downloadsLabel: '3.4M downloads',
          categoryLabel: 'Graphics',
          icon: Icons.pets_rounded,
          iconBackground: Color(0xFFFFE9E2),
          tagline: 'Edição de imagem madura com fluxo profissional e extensível.',
          about: 'Ferramentas avançadas de retoque, pintura e composição para fotografia e design.',
          version: '2.10.38',
          size: '264 MB',
          license: 'GPL-3.0',
          flatpakId: 'org.gimp.GIMP',
        ),
      ],
    ),
    CategoryData(
      id: 'utilities',
      title: 'Utilitários',
      description: 'Acessórios e ferramentas do sistema',
      icon: Icons.explore_outlined,
      iconColor: Color(0xFFE4A936),
      apps: [
        CategoryAppData(
          id: 'disk-lens',
          name: 'Disk Lens',
          publisher: 'Open System',
          rating: 4.4,
          ratingCountLabel: '(820)',
          downloadsLabel: '120k downloads',
          categoryLabel: 'Utilities',
          icon: Icons.search_rounded,
          iconBackground: Color(0xFFFFF0D9),
          tagline: 'Encontre rapidamente onde seu espaço em disco está indo.',
          about: 'Mapas de uso, limpeza de cache e inspeção de diretórios com visão temporal.',
          version: '1.4.0',
          size: '61 MB',
          license: 'GPL-3.0',
          flatpakId: 'org.opensystem.DiskLens',
        ),
      ],
    ),
    CategoryData(
      id: 'education',
      title: 'Educação',
      description: 'Aprendizado e referência',
      icon: Icons.menu_book_outlined,
      iconColor: Color(0xFF65A7D8),
      apps: [
        CategoryAppData(
          id: 'atlas-learn',
          name: 'Atlas Learn',
          publisher: 'Blue Atlas',
          rating: 4.5,
          ratingCountLabel: '(1.140)',
          downloadsLabel: '180k downloads',
          categoryLabel: 'Education',
          icon: Icons.school_outlined,
          iconBackground: Color(0xFFE0F0FF),
          tagline: 'Cursos, flashcards e trilhas de estudo em uma única mesa.',
          about: 'Conteúdo organizado por trilhas, revisão espaçada e estatísticas de progresso.',
          version: '3.1.2',
          size: '132 MB',
          license: 'Apache-2.0',
          flatpakId: 'org.blueatlas.AtlasLearn',
        ),
      ],
    ),
  ];

  static CategoryData? byId(String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category;
      }
    }

    return null;
  }

  static CategoryAppData? appById(String appId) {
    for (final category in categories) {
      for (final app in category.apps) {
        if (app.id == appId) {
          return app;
        }
      }
    }

    return null;
  }

  static CategoryAppData? appByFlatpakId(String flatpakId) {
    for (final category in categories) {
      for (final app in category.apps) {
        if (app.flatpakId == flatpakId) {
          return app;
        }
      }
    }

    return null;
  }

  static CategoryData? categoryByAppId(String appId) {
    for (final category in categories) {
      for (final app in category.apps) {
        if (app.id == appId) {
          return category;
        }
      }
    }

    return null;
  }

  static CategoryData? categoryByFlatpakId(String flatpakId) {
    for (final category in categories) {
      for (final app in category.apps) {
        if (app.flatpakId == flatpakId) {
          return category;
        }
      }
    }

    return null;
  }
}
