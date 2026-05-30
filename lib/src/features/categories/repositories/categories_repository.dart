import 'package:flutter/material.dart';
import 'package:pakmart/src/features/categories/data/categories_api.dart';
import 'package:pakmart/src/features/categories/models/category_remote_models.dart';

class CategoriesRepository {
  CategoriesRepository(this._api);

  final CategoriesApi _api;

  Future<List<CategoryShelfData>> fetchCategories() async {
    final ids = await _api.fetchCategories();
    if (ids.isEmpty) {
      return const <CategoryShelfData>[];
    }

    return ids.map(_toShelfData).toList(growable: false);
  }

  Future<CategoryAppsPageData?> fetchCategoryApps({
    required String category,
    required int page,
    int perPage = 24,
    CategorySortBy? sortBy,
  }) {
    return _api.fetchCategoryApps(category: category, page: page, perPage: perPage, sortBy: sortBy);
  }

  CategoryShelfData resolveCategoryPresentation(String categoryId) {
    return _toShelfData(categoryId);
  }

  CategoryShelfData _toShelfData(String rawId) {
    final id = rawId.trim().toLowerCase();
    final presentation = _map[id];
    if (presentation != null) {
      return CategoryShelfData(
        id: id,
        title: presentation.title,
        description: presentation.description,
        icon: presentation.icon,
        iconColor: presentation.color,
      );
    }

    return CategoryShelfData(
      id: id,
      title: _titleFromId(id),
      description: 'Aplicativos da categoria ${_titleFromId(id)}.',
      icon: Icons.grid_view_rounded,
      iconColor: const Color(0xFF7B8A97),
    );
  }

  String _titleFromId(String id) {
    if (id.isEmpty) {
      return 'Categoria';
    }

    final normalized = id.replaceAll('-', ' ').replaceAll('_', ' ').trim();
    if (normalized.isEmpty) {
      return 'Categoria';
    }

    final words = normalized.split(RegExp(r'\s+'));
    return words
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}

class _CategoryPresentation {
  const _CategoryPresentation({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

const Map<String, _CategoryPresentation> _map = {
  'audiovideo': _CategoryPresentation(
    title: 'Áudio e Vídeo',
    description: 'Players, editores e produção multimídia.',
    icon: Icons.music_note_rounded,
    color: Color(0xFF6A8595),
  ),
  'development': _CategoryPresentation(
    title: 'Desenvolvimento',
    description: 'IDEs, editores e ferramentas para devs.',
    icon: Icons.handyman_outlined,
    color: Color(0xFF7D9DB5),
  ),
  'education': _CategoryPresentation(
    title: 'Educação',
    description: 'Aprendizado, estudo e referência.',
    icon: Icons.menu_book_outlined,
    color: Color(0xFF65A7D8),
  ),
  'game': _CategoryPresentation(
    title: 'Jogos',
    description: 'Jogos, emuladores e launchers.',
    icon: Icons.sports_esports_rounded,
    color: Color(0xFF8F8F8F),
  ),
  'graphics': _CategoryPresentation(
    title: 'Gráficos',
    description: 'Edição de imagem, desenho e design.',
    icon: Icons.palette_outlined,
    color: Color(0xFFF2A24D),
  ),
  'network': _CategoryPresentation(
    title: 'Internet',
    description: 'Navegadores, comunicação e rede.',
    icon: Icons.public_rounded,
    color: Color(0xFF71B44C),
  ),
  'office': _CategoryPresentation(
    title: 'Escritório',
    description: 'Produtividade, documentos e planilhas.',
    icon: Icons.description_outlined,
    color: Color(0xFF6FA3FF),
  ),
  'science': _CategoryPresentation(
    title: 'Ciência',
    description: 'Pesquisa, cálculo e visualização científica.',
    icon: Icons.science_outlined,
    color: Color(0xFF8D7AC2),
  ),
  'system': _CategoryPresentation(
    title: 'Sistema',
    description: 'Utilitários e ferramentas de sistema.',
    icon: Icons.settings_suggest_rounded,
    color: Color(0xFF72919D),
  ),
  'utility': _CategoryPresentation(
    title: 'Utilitários',
    description: 'Apps úteis para tarefas do dia a dia.',
    icon: Icons.explore_outlined,
    color: Color(0xFFE4A936),
  ),
};
