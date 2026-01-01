import "Turbine";
import "Turbine.Gameplay";

DEFAULT_COMPLETION_DISTANCE = 15;

_LANG = {
    ['EN'] = {
        COMMAND_HELP = "shows Waypoint help",
        COMMAND_SHOW = "shows arrow",
        COMMAND_HIDE = "hides arrow",
        COMMAND_CONFIG = "shows Waypoint configuration",
        COMMAND_TARGET = "target coordinates for the arrow",
        AUTHOR_LINE = "%s by %s",
        TARGET_NEEDED = "Target needed",
        ARRIVED_AT = "Arrived @ \n%s",
        DISTANCE_AWAY = "~%sm away",
        DISTANCE_WITHIN = "within %dm",
        PATTERN_CHAT_LOC = 'You are on .+ server %d* at ',
        COMPLETION_DISTANCE_LABEL = "Completion distance:",
        COMMAND_LOC = "/loc",
    },
    ['FR'] = {
        COMMAND_HELP = "affiche l’aide de Waypoint",
        COMMAND_SHOW = "affiche la flèche",
        COMMAND_HIDE = "masque la flèche",
        COMMAND_CONFIG = "affiche la configuration de Waypoint",
        COMMAND_TARGET = "cibler des coordonnées pour la flèche",
        AUTHOR_LINE = "%s par %s",
        TARGET_NEEDED = "Cible nécessaire",
        ARRIVED_AT = "Arrivé @ %s",
        DISTANCE_AWAY = "~%sm de distance",
        DISTANCE_WITHIN = "à moins de %dm",
        PATTERN_CHAT_LOC = 'Vous vous trouvez sur .+ serveur %d*, à ',
        COMPLETION_DISTANCE_LABEL = "Distance d'accomplissement :",
        COMMAND_LOC = "/emp",
    },
    ['DE'] = {
        COMMAND_HELP = "zeigt Waypoint-Hilfe",
        COMMAND_SHOW = "zeigt den Pfeil",
        COMMAND_HIDE = "versteckt den Pfeil",
        COMMAND_CONFIG = "zeigt Waypoint-Konfiguration",
        COMMAND_TARGET = "Zielkoordinaten für den Pfeil festlegen",
        AUTHOR_LINE = "%s von %s",
        TARGET_NEEDED = "Ziel benötigt",
        ARRIVED_AT = "Ankommen @ \n%s",
        DISTANCE_AWAY = "~%sm entfernt",
        DISTANCE_WITHIN = "innerhalb von %dm",
        PATTERN_CHAT_LOC = 'Ihr seid auf dem Server .+ in ',
        COMPLETION_DISTANCE_LABEL = "Entfernung bis zur Fertigstellung:",
        COMMAND_LOC = "/pos",
    },
    ['RU'] = {
        COMMAND_HELP = "помощь по использованию Waypoint",
        COMMAND_SHOW = "показывает стрелку",
        COMMAND_HIDE = "убирает стрелку",
        COMMAND_CONFIG = "показывает настройки Waypoint",
        COMMAND_TARGET = "задать координаты для стрелки",
        AUTHOR_LINE = "%s от %s",
        TARGET_NEEDED = "Необходима цель",
        ARRIVED_AT = "Прибыли @ \n%s",
        DISTANCE_AWAY = "~%sм до цели",
        DISTANCE_WITHIN = "в пределах %dm",
        PATTERN_CHAT_LOC = 'Ваше местонахождение: .+, сервер %d*, ',
        COMPLETION_DISTANCE_LABEL = "Дистанция завершения:",
        COMMAND_LOC = "/loc",
    },
}

Turbine.Language.Russian = 0x10000007; -- removed in Update 22 and again in Update 34

-- Add detection for the Russian language client
Turbine.Engine._GetLanguage = Turbine.Engine.GetLanguage;
function Turbine.Engine.GetLanguage()
    local language = Turbine.Engine._GetLanguage();
    if (language == Turbine.Language.English) then
        local russianAlphabet = "АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя"; -- wide characters, 2 bytes each
        local skillName = Turbine.Gameplay.LocalPlayer:GetInstance():GetTrainedSkills():GetItem(1):GetSkillInfo():GetName();
        if (russianAlphabet:match(skillName:sub(1, 2))) then
            return Turbine.Language.Russian;
        end
    end
    return language;
end

LANGUAGE = Turbine.Engine.GetLanguage();
LOCALE = 'en';
for lang, val in pairs({
    en = Turbine.Language.English;
    de = Turbine.Language.German;
    fr = Turbine.Language.French;
    ru = Turbine.Language.Russian;
 }) do
    if (LANGUAGE == val) then
        LOCALE = lang;
    end
end

STRING = _LANG[LOCALE:upper()];