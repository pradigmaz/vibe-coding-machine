# Frontend Design Skill

## Назначение

Create distinctive, production-grade frontend interfaces. Используется frontend агентами для building web components, pages, applications с high design quality.

## Design Thinking

Before coding, understand context и commit к BOLD aesthetic direction:

- **Purpose**: What problem? Who uses it?
- **Tone**: Pick extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian
- **Constraints**: Technical requirements
- **Differentiation**: What makes this UNFORGETTABLE?

**CRITICAL**: Choose clear conceptual direction и execute с precision. Bold maximalism и refined minimalism both work - key is intentionality.

## Frontend Aesthetics Guidelines

### Typography

- Choose fonts beautiful, unique, interesting
- Avoid generic: Arial, Inter, Roboto
- Use distinctive choices
- Pair display font с refined body font

**Examples:**
```css
/* ✅ GOOD: Distinctive fonts */
font-family: 'Playfair Display', serif;
font-family: 'Space Mono', monospace;
font-family: 'Crimson Pro', serif;

/* ❌ BAD: Generic fonts */
font-family: Inter, sans-serif;
font-family: Arial, sans-serif;
font-family: system-ui;
```

### Color & Theme

- Commit к cohesive aesthetic
- Use CSS variables
- Dominant colors с sharp accents
- Avoid timid, evenly-distributed palettes

```css
/* ✅ GOOD: Bold color scheme */
:root {
  --primary: #FF6B35;
  --secondary: #004E89;
  --accent: #F7B801;
  --background: #0A0E27;
  --text: #E8F1F5;
}

/* ❌ BAD: Generic purple gradient */
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

### Motion

- Use animations для effects
- CSS-only для HTML
- Motion library для React
- Focus на high-impact moments
- Staggered reveals (animation-delay)
- Scroll-triggering и hover states

```css
/* ✅ GOOD: Staggered animation */
.item {
  animation: fadeIn 0.6s ease-out forwards;
  opacity: 0;
}

.item:nth-child(1) { animation-delay: 0.1s; }
.item:nth-child(2) { animation-delay: 0.2s; }
.item:nth-child(3) { animation-delay: 0.3s; }

@keyframes fadeIn {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Spatial Composition

- Unexpected layouts
- Asymmetry
- Overlap
- Diagonal flow
- Grid-breaking elements
- Generous negative space OR controlled density

```css
/* ✅ GOOD: Asymmetric layout */
.hero {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 4rem;
  align-items: start;
}

.feature {
  transform: rotate(-2deg);
  position: relative;
  z-index: 10;
}
```

### Backgrounds & Visual Details

- Create atmosphere и depth
- Gradient meshes
- Noise textures
- Geometric patterns
- Layered transparencies
- Dramatic shadows
- Decorative borders
- Custom cursors
- Grain overlays

```css
/* ✅ GOOD: Atmospheric background */
.hero {
  background: 
    radial-gradient(circle at 20% 50%, rgba(255,107,53,0.2) 0%, transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(0,78,137,0.2) 0%, transparent 50%),
    #0A0E27;
  position: relative;
}

.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' /%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.05'/%3E%3C/svg%3E");
  pointer-events: none;
}
```

## NEVER Use

- Generic AI aesthetics
- Overused fonts (Inter, Roboto, Arial, system fonts)
- Cliched color schemes (purple gradients на white)
- Predictable layouts
- Cookie-cutter design
- Same design across generations

## Implementation Complexity

**Match complexity к aesthetic vision:**

- **Maximalist designs**: Elaborate code, extensive animations, effects
- **Minimalist designs**: Restraint, precision, careful spacing, typography, subtle details

## Best Practices

```typescript
// ✅ GOOD: Distinctive design
<div className="hero" style={{
  fontFamily: "'Crimson Pro', serif",
  background: 'radial-gradient(circle at 20% 50%, rgba(255,107,53,0.2), transparent)',
  transform: 'rotate(-1deg)',
}}>
  <h1 style={{
    fontSize: 'clamp(3rem, 8vw, 6rem)',
    letterSpacing: '-0.02em',
    lineHeight: 1.1,
  }}>
    Unforgettable Headline
  </h1>
</div>

// ❌ BAD: Generic design
<div className="hero" style={{
  fontFamily: 'Inter, sans-serif',
  background: 'linear-gradient(135deg, #667eea, #764ba2)',
}}>
  <h1>Generic Headline</h1>
</div>
```

## Checklist

```
Frontend Design Review:
- [ ] Bold aesthetic direction chosen
- [ ] Distinctive fonts selected
- [ ] Cohesive color scheme
- [ ] Animations add impact
- [ ] Unexpected layout
- [ ] Atmospheric backgrounds
- [ ] No generic AI aesthetics
- [ ] Implementation matches vision
```

## Ресурсы

- [Fonts In Use](https://fontsinuse.com/)
- [Awwwards](https://www.awwwards.com/)
- [Codrops](https://tympanus.net/codrops/)
