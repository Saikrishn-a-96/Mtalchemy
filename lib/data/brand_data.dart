import 'package:flutter/material.dart';

import 'models.dart';

/// Static prototype content sourced from the MT Alchemy brief & profile.
class Brand {
  Brand._();

  static const String name = 'MT Alchemy';
  static const String tagline =
      'We don’t just run activities. We shift mindsets, behaviours, and team culture.';
  static const String headline =
      'Elevate your value: master human intelligence in a rapidly evolving AI-driven world.';
  static const String email = 'mabeltan.alchemy@gmail.com';
  static const String phone = '+6011-7239 9249';
  static const String address = 'Nilai, Negeri Sembilan, Malaysia';

  static const List<String> navLabels = [
    'Home',
    'About',
    'Services',
    'Upskilling',
    'Store',
    'Insights',
    'Contact',
  ];

  static const List<String> navRoutes = [
    '/',
    '/about',
    '/services',
    '/upskilling',
    '/store',
    '/insights',
    '/contact',
  ];

  static const List<String> learningCategories = [
    'Emotional Intelligence',
    'Mindfulness',
    'Leadership',
    'Communication',
    'Team Effectiveness',
    'Workplace Well-being',
    'Personal Development',
    'Organizational Development',
  ];

  static const List<String> journeyTags = [
    'Corporate',
    'Education',
    'Youth',
    'NGO',
    'Community',
    'Leadership',
    'Mindfulness',
    'Team Building',
  ];

  static const List<String> enquiryTypes = [
    'Individual Coaching',
    'Corporate Training',
    'Leadership Development',
    'Team Development',
    'Products',
    'Partnership',
    'Other',
  ];

  static const List<Map<String, String>> impactStats = [
    {'value': '1,100+', 'label': 'Participants impacted'},
    {'value': '120+', 'label': 'Programmes delivered'},
    {'value': '35+', 'label': 'Partner organisations'},
    {'value': '6', 'label': 'Specialist focus areas'},
  ];

  static const List<String> workplaceChallenges = [
    'Employee burnout',
    'Rising stress levels',
    'Communication breakdowns',
    'Team conflicts',
    'Leadership gaps',
    'Low employee engagement',
    'High turnover rates',
  ];

  static const List<String> orgOutcomes = [
    'Open communication',
    'Resilient leadership',
    'Higher employee engagement',
    'Improved team collaboration',
    'Increased workplace well-being',
    'Sustainable performance growth',
  ];
}

class Media {
  Media._();

  static const String u = 'https://images.unsplash.com/photo-';
  static const String q = '?auto=format&fit=crop&w=1400&q=80';
  static const String qs = '?auto=format&fit=crop&w=700&q=80';

  static const String heroTeam = '${u}1552664730-d307ca884978$q';
  static const String workshop = '${u}1531482615713-2afd69097998$q';
  static const String aboutTeam = '${u}1522071820081-009f0129c71c$q';
  static const String founder = '${u}1573496359142-b8d87734a5a2$qs';
  static const String teamMeeting = '${u}1517048676732-d65bc937f952$q';
  static const String planning = '${u}1542744173-8e7e53415bb0$q';
  static const String mentoring = '${u}1600880292203-757bb62b4baf$q';
  static const String analytics = '${u}1454165804606-c3d57bc86b40$q';
  static const String students = '${u}1543269865-cbf427effbad$q';
  static const String classroom = '${u}1524178232363-1fb2b075b655$q';
  static const String study = '${u}1544717297-fa95b6ee9643$q';
  static const String laptop = '${u}1499750310107-5fef28a66643$q';
  static const String mindfulness = '${u}1506126613408-eca07ce68773$q';
  static const String yoga = '${u}1571019613454-1cb2f99b2d8b$q';
  static const String whiteboard = '${u}1553877522-43269d4ea984$q';
  static const String office = '${u}1556761175-b413da4baf72$q';
  static const String coaching = '${u}1600880292089-90a7e086ee0c$q';
  static const String lecture = '${u}1509062522246-3755977927d7$q';
  static const String teamTech = '${u}1519389950473-47ba0277781c$q';
  static const String highFive = '${u}1521737711867-e3b97375f902$q';

  static const String bookOpen = '${u}1544947950-fa07a98d237f$qs';
  static const String books = '${u}1512820790803-83ca734da794$qs';
  static const String booksStack = '${u}1495446815901-a7297e633e8d$qs';
  static const String notebook = '${u}1517842645767-c639042777db$qs';
  static const String workspace = '${u}1531346878377-a5be20888e57$qs';
  static const String reading = '${u}1543002588-bfa74002ed7e$qs';
  static const String tote = '${u}1591561954557-26941169b49e$qs';
  static const String mug = '${u}1514228742587-6b1558fcca3d$qs';
  static const String journal = '${u}1589829085413-56de8ae18c73$qs';
  static const String desk = '${u}1519682337058-a94d519337bc$qs';

  static const String avatar1 = '${u}1494790108377-be9c29b29330$qs';
  static const String avatar2 = '${u}1472099645785-5658abf4ff4e$qs';
  static const String avatar3 = '${u}1438761681033-6461ffad8d80$qs';
  static const String avatar4 = '${u}1507003211169-0a1dd7228f2d$qs';
  static const String portraitM1 = '${u}1560250097-0b93528c311a$qs';
  static const String portraitW1 = '${u}1580489944761-15a19d654956$qs';
  static const String portraitW2 = '${u}1573496359142-b8d87734a5a2$qs';
}

class Content {
  Content._();

  static const List<ServiceItem> services = [
    ServiceItem(
      title: 'Emotional Intelligence & Mindfulness',
      summary:
          'Build workplace cultures that foster retention, engagement and lower burnout.',
      detail:
          'Shifts employees from reactive stress to deliberate focus. Lowers cortisol, mitigates chronic workplace anxiety and improves decision-making under pressure.',
      icon: Icons.self_improvement_rounded,
      accent: Color(0xFF6B4E9B),
      image: Media.mindfulness,
    ),
    ServiceItem(
      title: 'Leadership & Communication',
      summary:
          'Develop empathetic leaders who influence performance and organisational outcomes.',
      detail:
          'Practical labs on feedback, difficult conversations, presence and storytelling so leaders can align teams around a shared direction.',
      icon: Icons.trending_up_rounded,
      accent: Color(0xFF1E4E79),
      image: Media.workshop,
    ),
    ServiceItem(
      title: 'Organization Well-being Assessment',
      summary:
          'Diagnose stress, engagement and culture gaps with a structured assessment.',
      detail:
          'A confidential pulse survey plus focus-group debrief that maps risk areas and produces a prioritised 90-day well-being action plan.',
      icon: Icons.monitor_heart_rounded,
      accent: Color(0xFF2E8B84),
      image: Media.analytics,
    ),
    ServiceItem(
      title: 'Team Building & Team Effectiveness',
      summary:
          'Build the social fabric and mutual trust required for collective resilience.',
      detail:
          'Experiential activities adapted to diverse workforce and team demographics, followed by workplace application commitments.',
      icon: Icons.diversity_3_rounded,
      accent: Color(0xFFE98A15),
      image: Media.highFive,
    ),
    ServiceItem(
      title: 'Corporate Social Responsibility & ESG',
      summary:
          'Connect your workforce to meaningful community engagement initiatives.',
      detail:
          'Design of purpose-driven projects aligned with organisational values, with measurement of participation and community impact.',
      icon: Icons.eco_rounded,
      accent: Color(0xFF1E9E6A),
      image: Media.students,
    ),
    ServiceItem(
      title: 'Customized Programmes',
      summary: 'Programmes shaped around your workforce, industry and goals.',
      detail:
          'Modular delivery (workshops, coaching, digital learning) assembled around your audience, from 10-pilot groups to 300-person rollouts.',
      icon: Icons.auto_awesome_rounded,
      accent: Color(0xFF0C2340),
      image: Media.planning,
    ),
  ];

  static const List<Course> courses = [
    Course(
      id: 'eq-101',
      title: 'Emotional Intelligence Fundamentals',
      category: 'Emotional Intelligence',
      instructor: 'Mabel Tan KH',
      duration: '6h 30m',
      level: 'Beginner',
      modules: 5,
      rating: 4.9,
      price: 149,
      image: Media.mindfulness,
      blurb:
          'Understand, name and regulate emotions at work using a practical EQ framework you can apply the same day.',
      objectives: [
        'Map your emotional triggers and response patterns',
        'Apply a 4-step regulation technique under pressure',
        'Build empathy into everyday workplace conversations',
      ],
      curriculum: [
        'Module 1 — What Emotional Intelligence Really Is',
        'Module 2 — Self-Awareness & Trigger Mapping',
        'Module 3 — Regulation Under Pressure',
        'Module 4 — Empathy & Social Skills',
        'Module 5 — EQ at Work: Practice Lab',
      ],
    ),
    Course(
      id: 'mind-201',
      title: 'Mindfulness at Work',
      category: 'Mindfulness',
      instructor: 'Esther Ng',
      duration: '4h 15m',
      level: 'Beginner',
      modules: 4,
      rating: 4.8,
      price: 119,
      image: Media.yoga,
      blurb:
          'Short, repeatable mindfulness practices that reduce stress and improve focus during the working day.',
      objectives: [
        'Run a 5-minute reset between meetings',
        'Recognise early stress signals in the body',
        'Create a personal weekly practice plan',
      ],
      curriculum: [
        'Module 1 — The Science of Attention',
        'Module 2 — Breath & Body Anchors',
        'Module 3 — Mindful Communication',
        'Module 4 — Building the Habit',
      ],
    ),
    Course(
      id: 'lead-301',
      title: 'Lead with Clarity: Leadership Essentials',
      category: 'Leadership',
      instructor: 'Mabel Tan KH',
      duration: '8h 00m',
      level: 'Intermediate',
      modules: 6,
      rating: 4.9,
      price: 249,
      image: Media.workshop,
      blurb:
          'A leadership operating system for first-line and mid-level leaders: direction, decisions and difficult conversations.',
      objectives: [
        'Set clear direction and delegate with intent',
        'Give feedback that changes behaviour',
        'Lead a team through conflict constructively',
      ],
      curriculum: [
        'Module 1 — Leadership Presence',
        'Module 2 — Setting Direction',
        'Module 3 — Coaching Conversations',
        'Module 4 — Decision Making',
        'Module 5 — Conflict & Repair',
        'Module 6 — Your 30-Day Leadership Plan',
      ],
    ),
    Course(
      id: 'comm-210',
      title: 'Communicate with Impact',
      category: 'Communication',
      instructor: 'Esther Ng',
      duration: '3h 45m',
      level: 'Beginner',
      modules: 4,
      rating: 4.7,
      price: 99,
      image: Media.teamMeeting,
      blurb:
          'Structure messages, listen actively and adapt your style so stakeholders act on what you say.',
      objectives: [
        'Structure a message for busy stakeholders',
        'Listen for meaning, not for reply',
        'Adapt style across generations and roles',
      ],
      curriculum: [
        'Module 1 — Message Architecture',
        'Module 2 — Active Listening',
        'Module 3 — Difficult Messages',
        'Module 4 — Presenting with Confidence',
      ],
    ),
    Course(
      id: 'team-320',
      title: 'Building High-Trust Teams',
      category: 'Team Effectiveness',
      instructor: 'Mabel Tan KH',
      duration: '5h 20m',
      level: 'Intermediate',
      modules: 5,
      rating: 4.8,
      price: 189,
      image: Media.whiteboard,
      blurb:
          'Diagnose team dysfunction and rebuild trust, accountability and psychological safety.',
      objectives: [
        'Run a team health diagnostic',
        'Repair trust after a breakdown',
        'Set norms for accountability',
      ],
      curriculum: [
        'Module 1 — The Trust Equation',
        'Module 2 — Team Diagnostics',
        'Module 3 — Psychological Safety',
        'Module 4 — Accountability Agreements',
        'Module 5 — Sustaining the Gains',
      ],
    ),
    Course(
      id: 'well-410',
      title: 'Workplace Well-being Practitioner',
      category: 'Workplace Well-being',
      instructor: 'Esther Ng',
      duration: '7h 10m',
      level: 'Advanced',
      modules: 6,
      rating: 4.9,
      price: 279,
      image: Media.office,
      blurb:
          'Design and champion a well-being programme inside your organisation with measurable outcomes.',
      objectives: [
        'Build a well-being risk map',
        'Design interventions for burnout hotspots',
        'Report impact to leadership',
      ],
      curriculum: [
        'Module 1 — Well-being Foundations',
        'Module 2 — Assessment & Data',
        'Module 3 — Intervention Design',
        'Module 4 — Manager Enablement',
        'Module 5 — Measurement',
        'Module 6 — Capstone',
      ],
    ),
    Course(
      id: 'pers-120',
      title: 'Personal Growth & Self-Awareness',
      category: 'Personal Development',
      instructor: 'Mabel Tan KH',
      duration: '3h 30m',
      level: 'Beginner',
      modules: 4,
      rating: 4.7,
      price: 89,
      image: Media.study,
      blurb:
          'Clarify your values, strengths and next growth edge through guided reflection and tools.',
      objectives: [
        'Identify your signature strengths',
        'Clarify values that guide decisions',
        'Draft a personal growth plan',
      ],
      curriculum: [
        'Module 1 — Values Clarification',
        'Module 2 — Strengths Discovery',
        'Module 3 — Feedback & Reflection',
        'Module 4 — Growth Plan',
      ],
    ),
    Course(
      id: 'org-430',
      title: 'Organizational Development Foundations',
      category: 'Organizational Development',
      instructor: 'Mabel Tan KH',
      duration: '6h 00m',
      level: 'Advanced',
      modules: 5,
      rating: 4.8,
      price: 299,
      image: Media.planning,
      blurb:
          'Read organisational systems, diagnose culture and plan change that actually sticks.',
      objectives: [
        'Diagnose culture using system mapping',
        'Plan a change intervention',
        'Engage sponsors and resistors',
      ],
      curriculum: [
        'Module 1 — Systems Thinking',
        'Module 2 — Culture Diagnostics',
        'Module 3 — Change Models',
        'Module 4 — Engagement Strategy',
        'Module 5 — Sustaining Change',
      ],
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'Emotional Clarity Workbook',
      category: 'Workbooks',
      price: 45,
      isDigital: true,
      image: Media.bookOpen,
      blurb:
          'A 62-page printable workbook with EQ reflection prompts, trigger maps and weekly practice sheets.',
      rating: 4.9,
      reviews: 132,
    ),
    Product(
      id: 'p2',
      name: 'EQ Journal Template Pack',
      category: 'Templates',
      price: 35,
      isDigital: true,
      image: Media.notebook,
      blurb:
          '18 editable journal templates for Notion and Docs: daily check-in, mood log, gratitude and review.',
      rating: 4.8,
      reviews: 118,
    ),
    Product(
      id: 'p3',
      name: 'Mindfulness Card Deck (PDF)',
      category: 'Assessment Resources',
      price: 30,
      isDigital: true,
      image: Media.desk,
      blurb:
          '48 printable facilitator cards with breath, grounding and reflection activities for teams.',
      rating: 4.7,
      reviews: 86,
    ),
    Product(
      id: 'p4',
      name: 'Leadership Playbook E-book',
      category: 'E-books',
      price: 59,
      isDigital: true,
      image: Media.reading,
      blurb:
          'A field guide of 25 leadership conversations, frameworks and scripts for new managers.',
      rating: 4.9,
      reviews: 104,
    ),
    Product(
      id: 'p5',
      name: 'Printed EQ Workbook',
      category: 'Workbooks',
      price: 89,
      isDigital: false,
      image: Media.books,
      blurb:
          'Perfect-bound printed edition of the Emotional Clarity Workbook, shipped within 3 working days.',
      stock: 32,
      rating: 4.8,
      reviews: 97,
    ),
    Product(
      id: 'p6',
      name: 'Team Reflection Cards',
      category: 'Cards',
      price: 75,
      isDigital: false,
      image: Media.booksStack,
      blurb:
          'Physical deck of 60 team reflection cards for retrospectives, huddles and offsites.',
      stock: 18,
      rating: 4.7,
      reviews: 64,
    ),
    Product(
      id: 'p7',
      name: 'Well-being Learning Kit',
      category: 'Learning Kits',
      price: 189,
      isDigital: false,
      image: Media.workspace,
      blurb:
          'Facilitator kit: workbook, card deck, journal and progress tracker for a 6-week cohort.',
      stock: 9,
      rating: 4.9,
      reviews: 41,
    ),
    Product(
      id: 'p8',
      name: 'MT Alchemy Journal',
      category: 'Merchandise',
      price: 65,
      isDigital: false,
      image: Media.journal,
      blurb:
          'A5 hardcover journal with monthly reflection spreads and the MT Alchemy motto.',
      stock: 47,
      rating: 4.8,
      reviews: 78,
    ),
  ];

  static const List<ImpactStory> stories = [
    ImpactStory(
      title: 'Mindfulness & Team Building',
      clientType: 'NGO',
      programme: 'Mindfulness Practice',
      participants: 15,
      objective:
          'Help public servants slow down, pause and connect with their inner world and one another.',
      outcome:
          'Participants felt lighter, calmer and recharged to continue serving the community.',
      image: Media.mindfulness,
      tags: ['NGO', 'Community', 'Mindfulness'],
    ),
    ImpactStory(
      title: 'Leadership & Team Building',
      clientType: 'Corporate',
      programme: 'Leadership Lab',
      participants: 50,
      objective:
          'Develop problem-solving skills and boost creativity across a cross-functional cohort.',
      outcome:
          'Teams collaborated more effectively and approached challenges with fresh perspectives.',
      image: Media.whiteboard,
      tags: ['Corporate', 'Leadership', 'Team Building'],
    ),
    ImpactStory(
      title: 'Leadership & Communication Workshop',
      clientType: 'Youth',
      programme: 'Youth Leaders Track',
      participants: 10,
      objective:
          'Equip future leaders with EQ skills to understand themselves and foster authentic teamwork.',
      outcome:
          'Greater empathy, self-understanding and confidence in contributing to team decisions.',
      image: Media.classroom,
      tags: ['Youth', 'Leadership', 'Emotional Intelligence'],
    ),
    ImpactStory(
      title: 'Emotional Intelligence & Mindfulness',
      clientType: 'Education',
      programme: 'Educator Well-being',
      participants: 28,
      objective:
          'Support emotional release, self-awareness and inner clarity through expressive art.',
      outcome:
          'Educators felt calmer and better able to support their students’ emotional well-being.',
      image: Media.students,
      tags: ['Education', 'Mindfulness', 'Emotional Intelligence'],
    ),
    ImpactStory(
      title: 'Emotional Regulation Awareness Talk',
      clientType: 'Education',
      programme: 'EQ School Series',
      participants: 230,
      objective:
          'Equip students with practical tools to identify and manage their emotions effectively.',
      outcome:
          'Improved concentration, reduced impulsive reactions and greater resilience day-to-day.',
      image: Media.lecture,
      tags: ['Education', 'Youth', 'Emotional Intelligence'],
    ),
    ImpactStory(
      title: 'Leadership Workshop',
      clientType: 'Corporate',
      programme: 'Student Leadership',
      participants: 180,
      objective:
          'Build confidence to work in teams, express ideas and approach challenges creatively.',
      outcome:
          'Participants became more proactive and confident in decision-making and group settings.',
      image: Media.teamTech,
      tags: ['Corporate', 'Youth', 'Leadership'],
    ),
  ];

  static const List<Insight> insights = [
    Insight(
      title: 'Why mental health in Malaysia moved from 8.9% to 31.1%',
      category: 'Workplace',
      readTime: '6 min read',
      image: Media.office,
    ),
    Insight(
      title: 'The business case for emotional intelligence training',
      category: 'Emotional Intelligence',
      readTime: '8 min read',
      image: Media.teamMeeting,
    ),
    Insight(
      title: 'Five rituals that protect a team from burnout',
      category: 'Mindfulness',
      readTime: '5 min read',
      image: Media.mindfulness,
    ),
    Insight(
      title: 'Feedback that changes behaviour, not just mood',
      category: 'Leadership',
      readTime: '7 min read',
      image: Media.mentoring,
    ),
  ];

  static const List<QuizQuestion> quiz = [
    QuizQuestion(
      question:
          'Which statement best describes emotional intelligence at work?',
      options: [
        'Suppressing emotions to stay professional',
        'Recognising and managing emotions in yourself and others',
        'Being the most vocal person in the room',
        'Avoiding conflict at all costs',
      ],
      correctIndex: 1,
      explanation:
          'EQ is about perceiving, understanding and managing emotions — your own and other people’s — to make better decisions.',
    ),
    QuizQuestion(
      question:
          'A colleague becomes defensive during feedback. What is the best first move?',
      options: [
        'Repeat the feedback louder for clarity',
        'Pause, acknowledge emotion and re-state intent',
        'End the conversation immediately',
        'Send the feedback by email instead',
      ],
      correctIndex: 1,
      explanation:
          'Acknowledging emotion lowers threat response and keeps the conversation open before returning to the message.',
    ),
    QuizQuestion(
      question:
          'Mindfulness practice primarily trains which capacity?',
      options: [
        'Multitasking speed',
        'Sustained, non-judgemental attention',
        'Memorising more information',
        'Working longer hours',
      ],
      correctIndex: 1,
      explanation:
          'Mindfulness trains attention to be sustained and non-judgemental, which improves focus and stress regulation.',
    ),
    QuizQuestion(
      question: 'Psychological safety in a team means…',
      options: [
        'No disagreement ever occurs',
        'People can take risks without fear of humiliation',
        'Standards are lowered to keep peace',
        'Managers approve every decision',
      ],
      correctIndex: 1,
      explanation:
          'Psychological safety is the shared belief that the team is safe for interpersonal risk-taking — including speaking up.',
    ),
    QuizQuestion(
      question: 'Which is the strongest indicator of team trust?',
      options: [
        'Frequency of social events',
        'Willingness to admit mistakes openly',
        'Length of team meetings',
        'Number of managers present',
      ],
      correctIndex: 1,
      explanation:
          'Open admission of mistakes signals vulnerability-based trust, the core of high-performing teams.',
    ),
  ];

  static const List<Employee> employees = [
    Employee(
        name: 'Aisyah Rahman',
        department: 'Human Resources',
        course: 'Emotional Intelligence Fundamentals',
        progress: 80,
        status: 'In Progress',
        score: 82,
        email: 'aisyah@abcsdn.my',
        role: 'Learner'),
    Employee(
        name: 'Daniel Wong',
        department: 'Finance',
        course: 'Lead with Clarity',
        progress: 100,
        status: 'Completed',
        score: 95,
        email: 'daniel@abcsdn.my',
        role: 'Department Lead'),
    Employee(
        name: 'Priya Nair',
        department: 'Operations',
        course: 'Communicate with Impact',
        progress: 45,
        status: 'In Progress',
        score: 76,
        email: 'priya@abcsdn.my',
        role: 'Learner'),
    Employee(
        name: 'Jason Lee',
        department: 'Sales',
        course: 'Building High-Trust Teams',
        progress: 0,
        status: 'Not Started',
        email: 'jason@abcsdn.my',
        role: 'Learner'),
    Employee(
        name: 'Nurul Huda',
        department: 'Human Resources',
        course: 'Mindfulness at Work',
        progress: 100,
        status: 'Completed',
        score: 91,
        email: 'nurul@abcsdn.my',
        role: 'Learner'),
    Employee(
        name: 'Tan Wei Ming',
        department: 'Finance',
        course: 'Workplace Well-being Practitioner',
        progress: 25,
        status: 'In Progress',
        score: 68,
        email: 'wei.ming@abcsdn.my',
        role: 'Learner'),
  ];

  static const List<Map<String, String>> testimonials = [
    {
      'quote':
          'The workshop gave our team a shared language for difficult conversations. Six weeks on, people are still using it.',
      'name': 'Head of People',
      'org': 'Manufacturing, Selangor',
      'avatar': Media.avatar1,
    },
    {
      'quote':
          'Practical, human and grounded in evidence. Our managers finally have tools they use, not just slides they forget.',
      'name': 'Learning & Development Lead',
      'org': 'Financial Services, KL',
      'avatar': Media.avatar2,
    },
    {
      'quote':
          'Participants told us it was the first training where they could be honest. That is rare.',
      'name': 'Programme Director',
      'org': 'Education Sector',
      'avatar': Media.avatar3,
    },
  ];
}
