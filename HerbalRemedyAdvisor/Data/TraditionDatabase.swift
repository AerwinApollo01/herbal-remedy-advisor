import Foundation

struct TraditionDatabase {
    static let all: [Tradition] = [
        Tradition(
            id: "ayurveda",
            name: "Ayurveda",
            region: "India · South Asia",
            flag: "🇮🇳",
            sfSymbol: "figure.mind.and.body",
            color: "#B03020",
            desc: "One of the world's oldest holistic healing systems (~5,000 years old), Ayurveda originates in the sacred Vedic texts of ancient India. It balances the three biological energies — Vata, Pitta, and Kapha — through herbs, diet, yoga, and seasonal cleansing rituals called Panchakarma, seeking harmony between body, mind, and spirit.",
            tags: ["Dosha Balance", "Panchakarma", "Agni", "Anti-Ama"]
        ),
        Tradition(
            id: "tcm",
            name: "Traditional Chinese Medicine",
            region: "China · East Asia",
            flag: "🇨🇳",
            sfSymbol: "flame.fill",
            color: "#C03030",
            desc: "Rooted in over 3,000 years of practice, Traditional Chinese Medicine (TCM) views the body as a dynamic system of Qi (vital energy) flowing through meridians. The Huangdi Neijing (Yellow Emperor's Classic) established its foundations: balancing Yin and Yang, regulating the five organ systems, and using thousands of medicinal herbs to restore harmony.",
            tags: ["Qi Flow", "Yin & Yang", "Five Elements", "Jing Essence"]
        ),
        Tradition(
            id: "persian",
            name: "Persian Medicine",
            region: "Iran · Middle East",
            flag: "🇮🇷",
            sfSymbol: "sparkles",
            color: "#7B35A0",
            desc: "Persian Medicine — formalized by Ibn Sina (Avicenna) in his monumental Canon of Medicine (1025 CE) — synthesized Greek, Indian, and Islamic healing into the world's most comprehensive medieval medical system. It emphasizes temperament (Mizaj), the balance of four humors, and the use of fragrant, warming herbs like saffron, rose, and cardamom to heal body and soul.",
            tags: ["Mizaj Balance", "Four Humors", "Saffron Healing", "Ruh (Spirit)"]
        ),
        Tradition(
            id: "african",
            name: "African Herbalism",
            region: "Sub-Saharan Africa",
            flag: "🌍",
            sfSymbol: "globe.africa.europe.fill",
            color: "#D05010",
            desc: "African Herbalism encompasses thousands of distinct healing traditions across the continent, united by a worldview that health is inseparable from community and ancestral relationship. Sangoma healers of Southern Africa, Yoruba Babalawos of West Africa, and Bantu plant traditions of Central Africa share a reverence for plant spirits and the interconnection of physical and spiritual well-being.",
            tags: ["Ubuntu Healing", "Sangoma Wisdom", "Plant Spirits", "Ancestral Health"]
        ),
        Tradition(
            id: "latin",
            name: "Curanderismo",
            region: "Latin America · Mexico",
            flag: "🌿",
            sfSymbol: "leaf.fill",
            color: "#1A7A40",
            desc: "Curanderismo is the living healing tradition of Latin America, blending pre-Columbian Aztec and Mayan plant knowledge with Spanish Catholic herbalism and West African healing brought through the diaspora. Curanderas and curanderos use limpias (cleansing rituals), herbal baths, and medicinal plants from the Amazon, Andes, and Mesoamerica to restore the whole person.",
            tags: ["Limpia Cleanse", "Susto Healing", "Sacred Plants", "Amazonian Wisdom"]
        ),
        Tradition(
            id: "euro",
            name: "European Herbalism",
            region: "Europe · Mediterranean",
            flag: "🏛️",
            sfSymbol: "building.columns.fill",
            color: "#1A60A0",
            desc: "European Herbalism traces its roots to ancient Greek physicians like Hippocrates and Dioscorides, was preserved through Medieval monastic gardens, and refined by Renaissance healers like Paracelsus and Hildegard von Bingen. It forms the foundation of modern pharmacy while retaining a living folk tradition of using local plants — garlic, valerian, elderberry, and thyme — for everyday healing.",
            tags: ["Hippocratic Tradition", "Monastic Herbalism", "Humoral Theory", "Wild Crafting"]
        ),
        Tradition(
            id: "folk",
            name: "Southeast Asian Folk Medicine",
            region: "Thailand · Vietnam · Indonesia",
            flag: "🇹🇭",
            sfSymbol: "globe.asia.australia.fill",
            color: "#C08010",
            desc: "Southeast Asian Folk Medicine weaves together Indian Ayurvedic influence, Chinese medical theory, and indigenous Austronesian plant wisdom into vibrant living traditions. Thai Tamra Phaet, Indonesian Jamu, Balinese Usada, and Vietnamese folk healing all share a deep reverence for tropical plant biodiversity — using turmeric, galangal, lemongrass, and papaya in complex preparations passed down through generations.",
            tags: ["Jamu Tradition", "Tropical Herbs", "Thai Herbal", "Ancestral Recipes"]
        )
    ]

    static func tradition(for tid: String) -> Tradition? {
        all.first { $0.id == tid }
    }
}
